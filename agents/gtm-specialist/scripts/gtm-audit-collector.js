/**
 * GTM Audit Collector — Single-Pass Chrome DevTools MCP Script
 *
 * PURPOSE: Run ONCE via mcp__chrome-devtools__evaluate_script to collect ALL data
 * needed for the 14-point GTM performance audit. Eliminates the need for multiple
 * separate script executions and associated permission prompts.
 *
 * USAGE:
 *   1. Read this file with the Read tool
 *   2. Navigate to the target URL with mcp__chrome-devtools__navigate_page
 *   3. Run the entire file content as a single mcp__chrome-devtools__evaluate_script call
 *   4. Parse the returned JSON — no further evaluate_script calls needed
 *
 * ASYNC: This function is async so it can fetch the GTM container source in-band.
 * Chrome DevTools MCP supports async functions — await is fully supported.
 *
 * COVERS:
 *   - Tag manager detection (GTM, Adobe Launch, Tealium, Segment, mParticle, etc.)
 *   - Performance timing, paint metrics, Core Web Vitals, Long Tasks
 *   - Resource timing for 50+ tracking/analytics domains
 *   - Script blocking chain analysis with full inline content
 *   - GTM container source fetch + structure analysis (tag counts, vendor IDs)
 *   - drupalSettings / wp_settings extraction (CMS config)
 *   - DataLayer contents and unique events
 *   - Consent platform detection (GCM v2, TrustArc, OneTrust, CookieBot, Didomi, etc.)
 *   - Cookie snapshot (consent cookies, analytics cookies)
 *   - Window-global vendor fingerprinting (60+ vendors)
 *   - GA4/Ads ID extraction from all inline scripts
 *   - Resource hints inventory
 *   - Form detection (Gravity Forms, WP forms, Drupal webforms)
 *   - CMS detection (Drupal, WordPress, Shopify, etc.)
 *   - WordPress plugin/theme inventory from page source
 *   - Session recorder IDs (Hotjar, Mouseflow, Clarity)
 *   - HubSpot portal/form IDs
 *   - Extended GTM container tag types (__hjtc, __mf, __gclidw, __ua, __sp, etc.)
 */

async () => {
  const result = {
    timestamp: new Date().toISOString(),
    url: window.location.href,
    userAgent: navigator.userAgent,
    gtm: {},
    performance: {},
    scripts: {},
    network: {},
    consent: {},
    datalayer: {},
    vendors: {},
    cms: {},
    cookies: {},
    forms: {},
    errors: []
  };

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  const safe = (label, fn) => {
    try { fn(); } catch (e) { result.errors.push(`${label}: ${e.message}`); }
  };

  const safeAsync = async (label, fn) => {
    try { await fn(); } catch (e) { result.errors.push(`${label}: ${e.message}`); }
  };

  const matchesDomain = (url, domains) => domains.some(d => url.includes(d));

  // Extract all content from all scripts (for regex scanning)
  const getAllScriptContent = () =>
    Array.from(document.querySelectorAll('script'))
      .map(s => (s.src || '') + ' ' + (s.textContent || ''))
      .join('\n');

  // ─────────────────────────────────────────────────────────────────────────
  // 1. CMS / PLATFORM DETECTION
  // ─────────────────────────────────────────────────────────────────────────

  safe('cms_detection', () => {
    const cms = {};

    // Drupal
    const drupalSettings = window.drupalSettings;
    cms.drupal = {
      present: !!drupalSettings || !!document.querySelector('[data-drupal-link-system-path]'),
      version: document.querySelector('meta[name="generator"]')?.content?.match(/Drupal (\d+)/)?.[1] || null,
      settings: drupalSettings ? {
        gtm: drupalSettings.gtm || null,
        gtag: drupalSettings.gtag || null,
        path: drupalSettings.path || null,
        user: { uid: drupalSettings.user?.uid || 0 } // 0 = anonymous
      } : null
    };

    // WordPress
    cms.wordpress = {
      present: !!(window.wp || document.querySelector('link[rel="https://api.w.org/"]') ||
                  document.querySelector('meta[name="generator"][content*="WordPress"]')),
      version: document.querySelector('meta[name="generator"][content*="WordPress"]')
               ?.content?.match(/WordPress ([\d.]+)/)?.[1] || null,
      // Check for WooCommerce
      woocommerce: !!window.wc_params || !!window.woocommerce_params || !!document.querySelector('.woocommerce'),
      // Check for GTM4WP
      gtm4wp: !!(window.dataLayer && window.gtm4wp_order_data !== undefined) || !!document.querySelector('#gtm4wp'),
      // wp_settings equivalent
      wpSettings: window.wpApiSettings || null
    };

    // Shopify
    cms.shopify = {
      present: !!window.Shopify,
      shop: window.Shopify?.shop || null,
      currency: window.Shopify?.currency?.active || null
    };

    // Squarespace
    cms.squarespace = { present: !!window.Static?.SQUARESPACE_CONTEXT };

    // Webflow
    cms.webflow = { present: !!window.Webflow };

    // Next.js / React / Vue
    cms.nextjs = { present: !!window.__NEXT_DATA__ };
    cms.gatsby = { present: !!window.___gatsby };
    cms.nuxt = { present: !!window.__NUXT__ };

    result.cms = cms;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 2. TAG MANAGER DETECTION
  // ─────────────────────────────────────────────────────────────────────────

  safe('tag_managers', () => {
    const tm = {};

    // Google Tag Manager
    const gtmIds = [];
    if (window.google_tag_manager) {
      Object.keys(window.google_tag_manager).forEach(k => {
        if (/^GTM-/.test(k)) gtmIds.push(k);
      });
    }
    document.querySelectorAll('script[src*="googletagmanager.com"]').forEach(s => {
      const m = s.src.match(/[?&]id=(GTM-[^&]+)/);
      if (m) gtmIds.push(m[1]);
    });
    // Also check noscript iframes
    document.querySelectorAll('noscript iframe[src*="googletagmanager.com"]').forEach(el => {
      const m = el.src.match(/[?&]id=(GTM-[^&]+)/);
      if (m) gtmIds.push(m[1]);
    });
    // Check drupalSettings
    const dsGtmIds = window.drupalSettings?.gtm?.tagIds || [];
    gtmIds.push(...dsGtmIds);

    tm.gtm = {
      present: gtmIds.length > 0 || !!window.google_tag_manager,
      containerIds: [...new Set(gtmIds)],
      state: {}
    };
    if (window.google_tag_manager) {
      Object.keys(window.google_tag_manager).forEach(key => {
        if (key.startsWith('GTM-')) {
          const c = window.google_tag_manager[key];
          tm.gtm.state[key] = { loaded: true, dataLayerName: c?.dataLayer?.name || 'dataLayer' };
        }
      });
    }

    tm.adobeLaunch = {
      present: !!(window._satellite || window.s_account || window.AppMeasurement),
      version: window._satellite?.buildInfo?.buildDate || null,
      environment: window._satellite?.environment?.id || null
    };
    tm.tealium = {
      present: !!(window.utag || window.utag_data),
      account: window.utag?.cfg?.account || null,
      profile: window.utag?.cfg?.profile || null
    };
    tm.segment = {
      present: !!(window.analytics && window.analytics.initialized),
      writeKey: window.analytics?.settings?.writeKey || null
    };
    tm.mparticle = { present: !!(window.mParticle && window.mParticle.isInitialized?.()) };
    tm.ensighten = { present: !!window.Bootstrapper };
    tm.commandersAct = { present: !!(window.tc_vars || window.tcvars) };
    tm.piwikPro = { present: !!(window._ppas_tm || window.ppms) };

    result.gtm = tm.gtm;
    result.vendors.tagManagers = tm;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 3. PERFORMANCE TIMING
  // ─────────────────────────────────────────────────────────────────────────

  safe('navigation_timing', () => {
    const nav = performance.getEntriesByType('navigation')[0];
    if (nav) {
      result.performance.navigation = {
        ttfb: Math.round(nav.responseStart - nav.startTime),
        domInteractive: Math.round(nav.domInteractive - nav.startTime),
        domContentLoaded: Math.round(nav.domContentLoadedEventEnd - nav.startTime),
        loadComplete: Math.round(nav.loadEventEnd - nav.startTime),
        transferSize: nav.transferSize,
        encodedBodySize: nav.encodedBodySize,
        decodedBodySize: nav.decodedBodySize,
        protocol: nav.nextHopProtocol
      };
    }
  });

  safe('paint_metrics', () => {
    result.performance.paint = {};
    performance.getEntriesByType('paint').forEach(p => {
      result.performance.paint[p.name] = Math.round(p.startTime);
    });
  });

  safe('core_web_vitals', () => {
    const cwv = {};
    const lcpEntries = performance.getEntriesByType('largest-contentful-paint');
    if (lcpEntries.length) {
      const lcp = lcpEntries[lcpEntries.length - 1];
      cwv.lcp = {
        value: Math.round(lcp.startTime),
        rating: lcp.startTime < 2500 ? 'good' : lcp.startTime < 4000 ? 'needs-improvement' : 'poor',
        element: lcp.element?.tagName || 'unknown',
        elementId: lcp.element?.id || null,
        elementClass: lcp.element?.className?.slice?.(0, 80) || null,
        size: lcp.size,
        url: lcp.url || null
      };
    }
    let clsValue = 0;
    performance.getEntriesByType('layout-shift').forEach(e => {
      if (!e.hadRecentInput) clsValue += e.value;
    });
    cwv.cls = {
      value: Math.round(clsValue * 1000) / 1000,
      rating: clsValue < 0.1 ? 'good' : clsValue < 0.25 ? 'needs-improvement' : 'poor'
    };
    const eventTimings = performance.getEntriesByType('event');
    if (eventTimings.length) {
      const sorted = eventTimings.map(e => e.duration).sort((a, b) => b - a);
      cwv.inp_estimate = {
        value: Math.round(sorted[0]),
        p75: Math.round(sorted[Math.floor(sorted.length * 0.25)] || sorted[0]),
        rating: sorted[0] < 200 ? 'good' : sorted[0] < 500 ? 'needs-improvement' : 'poor',
        sampleCount: sorted.length
      };
    }
    const fcp = performance.getEntriesByType('paint').find(p => p.name === 'first-contentful-paint');
    if (fcp) {
      cwv.fcp = {
        value: Math.round(fcp.startTime),
        rating: fcp.startTime < 1800 ? 'good' : fcp.startTime < 3000 ? 'needs-improvement' : 'poor'
      };
    }
    result.performance.cwv = cwv;
  });

  safe('long_tasks', () => {
    const tasks = performance.getEntriesByType('longtask');
    result.performance.longTasks = {
      count: tasks.length,
      totalBlockingTime: Math.round(tasks.reduce((s, t) => s + Math.max(0, t.duration - 50), 0)),
      totalDuration: Math.round(tasks.reduce((s, t) => s + t.duration, 0)),
      tasks: tasks.slice(0, 20).map(t => ({
        startTime: Math.round(t.startTime),
        duration: Math.round(t.duration),
        attribution: t.attribution?.[0]?.name || 'unknown'
      }))
    };
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 4. RESOURCE TIMING — All third-party tracking scripts
  // ─────────────────────────────────────────────────────────────────────────

  safe('resource_timing', () => {
    const resources = performance.getEntriesByType('resource');
    const pageHost = window.location.hostname;

    const TRACKING_DOMAINS = [
      // Google
      'googletagmanager.com', 'google-analytics.com', 'googleadservices.com',
      'googlesyndication.com', 'doubleclick.net', 'googletagservices.com',
      'g.co', 'gstatic.com', 'google.com/pagead', 'google.com/recaptcha',
      // Meta / Facebook
      'connect.facebook.net', 'facebook.com/tr', 'fbcdn.net', 'fbsbx.com',
      // Microsoft / Bing
      'bat.bing.com', 'clarity.ms', 'c.bing.com', 'c.clarity.ms',
      // Adobe
      'assets.adobedtm.com', 'sc.omtrdc.net', 'demdex.net', 'omtrdc.net',
      'adobedc.net', 'adobe.com',
      // Twitter / X
      'analytics.twitter.com', 'static.ads-twitter.com', 't.co', 'ads-twitter.com',
      // LinkedIn
      'cdn.linkedin.com', 'px.ads.linkedin.com', 'snap.licdn.com', 'linkedin.com/px',
      // Pinterest
      'ct.pinterest.com', 'pinimg.com', 'pinterest.com',
      // Snapchat
      'sc-static.net', 'ads.snapchat.com', 'tr.snapchat.com',
      // TikTok
      'analytics.tiktok.com', 'tiktok.com/i18n', 'tiktokcdn.com', 'tteng.cn',
      // Trade Desk
      'js.adsrvr.org', 'match.adsrvr.org', 'insight.adsrvr.org',
      // StackAdapt
      'tags.srv.stackadapt.com', 'srv.stackadapt.com',
      // AdRoll
      's.adroll.com', 'pixel.adroll.com', 'd.adroll.com', 'fls.adroll.com',
      // Criteo
      'static.criteo.net', 'cas.criteo.com', 'gum.criteo.com', 'dis.criteo.com',
      // Taboola
      'cdn.taboola.com', 'trc.taboola.com', 'nr-data.taboola.com',
      // Outbrain
      'amplify.outbrain.com', 'widgets.outbrain.com', 'log.outbrain.com',
      // Spotify
      'pixel.byspotify.com',
      // LiveRamp / Raft
      'cdn.rlcdn.com', 'launchpad.privacymanager.io', 'idsync.rlcdn.com',
      // Magellan
      'cdn.mgln.ai',
      // Veritone / SourcePoint
      'cdn.sourcepoint.com', 'ov-e.com',
      // New Relic
      'bam.nr-data.net', 'js-agent.newrelic.com',
      // Dynatrace
      'dt.com', 'dynatrace.com', 'dynatracelabs.com',
      // Hotjar
      'static.hotjar.com', 'vars.hotjar.com', 'in.hotjar.com',
      // FullStory
      'edge.fullstory.com', 'rs.fullstory.com', 'fullstory.com',
      // Heap
      'cdn.heapanalytics.com', 'heapanalytics.com',
      // Amplitude
      'cdn.amplitude.com', 'api.amplitude.com', 'api2.amplitude.com',
      // Mixpanel
      'cdn.mxpnl.com', 'api.mixpanel.com',
      // Segment
      'cdn.segment.com', 'api.segment.io', 'evs.segment.com',
      // HubSpot
      'js.hs-scripts.com', 'js.hubspot.com', 'forms.hsforms.com', 'js.hscta.net',
      // Intercom
      'js.intercomcdn.com', 'widget.intercom.io', 'api-iam.intercom.io',
      // Drift
      'js.driftt.com', 'js.drift.com', 'event.drift.com',
      // Salesforce
      'pi.pardot.com', 'mc.exacttarget.com', 'exacttarget.com',
      // Marketo
      'mktoresp.com', 'munchkin.marketo.net',
      // Quantcast
      'quantserve.com', 'pixel.quantserve.com',
      // comScore
      'sb.scorecardresearch.com', 'beacon.scorecardresearch.com',
      // Chartbeat
      'static.chartbeat.com', 'ping.chartbeat.net',
      // Optimizely
      'cdn.optimizely.com', 'logx.optimizely.com',
      // VWO
      'dev.visualwebsiteoptimizer.com', 'app.vwo.com', 'vis.opt.com',
      // Crazy Egg
      'script.crazyegg.com',
      // Consent / CMP
      'consent.trustarc.com', 'optanon.blob.core.windows.net',
      'cdn.cookielaw.org', 'geolocation.onetrust.com',
      'app.cookieinformation.com', 'delivery.consentmanager.net',
      'cookie-cdn.cookiepro.com',
      // YouTube / Video
      'youtube.com', 'youtu.be', 'ytimg.com', 'yt3.ggpht.com',
      // Google reCAPTCHA
      'www.gstatic.com/recaptcha',
      // Zendesk
      'static.zdassets.com', 'ekr.zdassets.com',
      // Qualified
      'js.qualified.com',
      // 6sense
      '6sense.com', 'b2bapi.6sense.com',
      // Mouseflow
      'cdn.mouseflow.com', 'o2.mouseflow.com', 'mouseflow.com',
      // Lucky Orange
      'cdn.luckyorange.com', 'w1.luckyorange.com',
      // Smartlook
      'rec.smartlook.com', 'manager.smartlook.cloud',
      // Sprig / UserLeap
      'cdn.sprig.com', 'api.sprig.com',
      // Qualtrics
      'siteintercept.qualtrics.com', 'cdn.qualtrics.com',
      // CallRail
      'cdn.callrail.com', 'mod.callrail.com',
      // Invoca
      'solutions.invocacdn.com',
      // Demandbase
      'tag.demandbase.com', 'api.company-target.com',
    ];

    const gtmResources = [];
    const thirdPartyTracking = [];
    const thirdPartyOther = [];

    resources.forEach(r => {
      const url = r.name;
      let host;
      try { host = new URL(url).hostname; } catch { return; }
      const isFirstParty = host === pageHost || host.endsWith('.' + pageHost);

      const entry = {
        url,
        host,
        duration: Math.round(r.duration),
        transferSize: r.transferSize || 0,
        encodedBodySize: r.encodedBodySize || 0,
        startTime: Math.round(r.startTime),
        initiatorType: r.initiatorType,
        renderBlocking: r.renderBlockingStatus || 'unknown',
        protocol: r.nextHopProtocol || 'unknown'
      };

      if (url.includes('googletagmanager.com') || url.includes('/gtm.js') || url.includes('/gtag.js')) {
        gtmResources.push(entry);
      } else if (!isFirstParty && matchesDomain(url, TRACKING_DOMAINS)) {
        thirdPartyTracking.push(entry);
      } else if (!isFirstParty) {
        thirdPartyOther.push({ url, host, transferSize: r.transferSize || 0 });
      }
    });

    const byStart = (a, b) => a.startTime - b.startTime;
    result.network.gtmResources = gtmResources.sort(byStart);
    result.network.thirdPartyTracking = thirdPartyTracking.sort(byStart);
    result.network.thirdPartyOther = thirdPartyOther.slice(0, 20); // cap for readability
    result.network.selfHostedCount = resources.filter(r => {
      try { const h = new URL(r.name).hostname; return h === pageHost || h.endsWith('.' + pageHost); } catch { return false; }
    }).length;
    result.network.totalThirdPartyCount = thirdPartyTracking.length;
    result.network.totalThirdPartyBytes = thirdPartyTracking.reduce((s, r) => s + r.transferSize, 0);
    result.network.totalGtmBytes = gtmResources.reduce((s, r) => s + r.transferSize, 0);
    result.network.uniqueThirdPartyDomains = [...new Set(thirdPartyTracking.map(r => r.host))];
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 5. SCRIPT TAG ANALYSIS — Full inline content, blocking chain
  // ─────────────────────────────────────────────────────────────────────────

  safe('head_scripts', () => {
    const INLINE_FULL_THRESHOLD = 2000; // bytes — capture full content below this
    const INLINE_SNIPPET_MAX = 500;     // bytes — snippet for larger scripts

    // Known inline script patterns for vendor identification
    const identifyInlineVendor = content => {
      if (content.includes('NREUM') || content.includes('newrelic') || content.includes('nr_agent')) return 'New Relic Browser Agent';
      if (content.includes('googletagmanager') || content.includes('gtm.start')) return 'GTM Initialization';
      if (content.includes('gtag(') && content.includes('G-')) return 'GA4 gtag initialization';
      if (content.includes('fbq(') || content.includes('fbevents')) return 'Meta Pixel';
      if (content.includes('trustarc') || content.includes('truste')) return 'TrustArc CMP';
      if (content.includes('OneTrust') || content.includes('optanon')) return 'OneTrust CMP';
      if (content.includes('Cookiebot')) return 'CookieBot';
      if (content.includes('@context') && content.includes('schema.org')) return 'Schema.org JSON-LD';
      if (content.includes('drupalSettings') || content.includes('Drupal.settings')) return 'Drupal Settings';
      if (content.includes('var wpApiSettings') || content.includes('wp.i18n')) return 'WordPress Settings';
      if (content.includes('dataLayer') && content.includes('push')) return 'dataLayer Push';
      if (content.includes('setInterval') || content.includes('setTimeout')) return 'Polling/Timer Script';
      if (content.includes('_satellite')) return 'Adobe Launch';
      if (content.includes('utag')) return 'Tealium iQ';
      if (content.includes('clarity(') || content.includes('clarity.ms')) return 'Microsoft Clarity';
      if (content.includes('hotjar') || content.includes('(h,o,t,j,a,r)')) return 'Hotjar';
      if (content.includes('mouseflow') || content.includes('_mfq')) return 'Mouseflow';
      if (content.includes('hbspt') || content.includes('hsforms') || content.includes('hs-scripts')) return 'HubSpot';
      if (content.includes('calltrk') || content.includes('callrail')) return 'CallRail';
      if (content.includes('qualified') && content.includes('load')) return 'Qualified';
      if (content.includes('LD+JSON') || content.includes('application/ld+json')) return 'JSON-LD';
      return null;
    };

    const analyzeScript = s => {
      const content = s.textContent || '';
      const isInline = !s.src;
      const isSmall = content.length <= INLINE_FULL_THRESHOLD;

      return {
        src: s.src || null,
        async: s.async,
        defer: s.defer,
        type: s.type || 'text/javascript',
        isModule: s.type === 'module',
        isBlocking: !!s.src && !s.async && !s.defer && s.type !== 'module',
        isInline,
        inlineSize: isInline ? content.length : null,
        // Full content for small scripts, snippet for large ones
        inlineContent: isInline ? (isSmall ? content : content.slice(0, INLINE_SNIPPET_MAX) + '... [truncated]') : null,
        vendor: isInline
          ? identifyInlineVendor(content)
          : (s.src.includes('googletagmanager') ? 'GTM' :
             s.src.includes('google-analytics') ? 'GA' :
             s.src.includes('fbevents') ? 'Meta Pixel' :
             s.src.includes('newrelic') ? 'New Relic' :
             s.src.includes('trustarc') ? 'TrustArc' :
             s.src.includes('cookielaw') ? 'OneTrust' :
             s.src.includes('hotjar') ? 'Hotjar' :
             s.src.includes('clarity.ms') ? 'Microsoft Clarity' :
             s.src.includes('adsrvr') ? 'Trade Desk' :
             s.src.includes('stackadapt') ? 'StackAdapt' :
             s.src.includes('adroll') ? 'AdRoll' :
             s.src.includes('mouseflow') ? 'Mouseflow' :
             s.src.includes('hsforms') || s.src.includes('hs-scripts') || s.src.includes('hubspot') ? 'HubSpot' :
             s.src.includes('callrail') ? 'CallRail' :
             s.src.includes('qualified') ? 'Qualified' :
             null),
        // Flag for review if large inline or contains risky patterns
        reviewFlag: isInline && content.length > 10000 ? 'LARGE_INLINE' :
                    isInline && content.includes('setInterval') ? 'POLLING' :
                    isInline && content.includes('document.write') ? 'DOCUMENT_WRITE' :
                    isInline && content.includes('eval(') ? 'EVAL' :
                    null
      };
    };

    const headScripts = Array.from(document.querySelectorAll('head script')).map(analyzeScript);
    const bodyScripts = Array.from(document.querySelectorAll('body script')).slice(0, 50).map(analyzeScript);

    result.scripts.head = headScripts;
    result.scripts.body = bodyScripts;
    result.scripts.bodyCount = document.querySelectorAll('body script').length;
    result.scripts.blockingHeadScripts = headScripts.filter(s => s.isBlocking);
    result.scripts.blockingHeadCount = headScripts.filter(s => s.isBlocking).length;
    result.scripts.blockingBodyCount = bodyScripts.filter(s => s.isBlocking).length;
    result.scripts.totalHeadInlineSize = headScripts.filter(s => s.isInline).reduce((sum, s) => sum + (s.inlineSize || 0), 0);
    result.scripts.flaggedForReview = [
      ...headScripts.filter(s => s.reviewFlag),
      ...bodyScripts.filter(s => s.reviewFlag)
    ];
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 6. DATALAYER ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────

  safe('datalayer', () => {
    const layerName = window.dataLayer ? 'dataLayer' : window.utag_data ? 'utag_data' : null;

    if (layerName && Array.isArray(window[layerName])) {
      const dl = window[layerName];
      result.datalayer = {
        exists: true,
        name: layerName,
        eventCount: dl.length,
        totalSizeBytes: JSON.stringify(dl).length,
        uniqueEvents: [...new Set(dl.map(i => i?.event).filter(Boolean))],
        recentEvents: dl.slice(-20).map(item => ({
          event: item?.event || '(push)',
          keys: Object.keys(item || {}),
          hasGtmStart: !!(item?.['gtm.start'])
        })),
        ga4Ids: [...new Set(dl.flatMap(i => (JSON.stringify(i || {}).match(/G-[A-Z0-9]{8,12}/g) || [])))],
        // Detect ecommerce pushes
        hasEcommerce: dl.some(i => i?.ecommerce || i?.['gtm.element.dataset']?.ecommerce),
        // Detect consent pushes
        hasConsentPush: dl.some(i => Array.isArray(i) && i[0] === 'consent')
      };
    } else {
      result.datalayer = { exists: false, name: null };
    }
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 7. CONSENT PLATFORM DETECTION
  // ─────────────────────────────────────────────────────────────────────────

  safe('consent', () => {
    const consent = {};

    consent.googleConsentMode = { v2Defaults: false, calls: [], currentState: null };
    if (window.dataLayer) {
      const consentCalls = window.dataLayer.filter(d =>
        Array.isArray(d) ? d[0] === 'consent' : d?.['0'] === 'consent'
      );
      consent.googleConsentMode.v2Defaults = consentCalls.length > 0;
      consent.googleConsentMode.calls = consentCalls.slice(0, 5);
    }
    if (window.__gcl || window.__gpi) consent.googleConsentMode.currentState = window.__gcl || window.__gpi;

    consent.tcfV2 = { present: typeof window.__tcfapi === 'function' };
    if (typeof window.__tcfapi === 'function') {
      try {
        window.__tcfapi('getTCData', 2, d => {
          consent.tcfV2.tcStringPresent = !!d?.tcString;
          consent.tcfV2.gdprApplies = d?.gdprApplies;
        });
      } catch (e) { /* silent */ }
    }

    consent.trustArc = {
      present: !!(window.truste || document.querySelector('[src*="trustarc"]')),
      cmId: document.querySelector('[src*="trustarc"]')?.src?.match(/cmId=([^&]+)/)?.[1] || null,
      autoblock: !!document.querySelector('[src*="autoblockasset"]')
    };
    consent.oneTrust = {
      present: !!(window.OneTrust || window.OnetrustActiveGroups),
      activeGroups: window.OnetrustActiveGroups || null,
      geolocationEnabled: !!window.OneTrust?.getGeolocationData
    };
    consent.cookieBot = {
      present: !!(window.CookieConsent || document.querySelector('#CookieConsent')),
      consent: window.CookieConsent?.consent || null
    };
    consent.didomi = {
      present: !!window.Didomi,
      ready: !!window.didomiOnReady
    };
    consent.osano = { present: !!window.Osano };
    consent.quantcastChoice = { present: !!window.__cmp };
    consent.consentManager = { present: !!window.cmp_block };
    consent.userCentrics = { present: !!window.usercentrics || !!window.UC_UI };

    result.consent = consent;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 8. COOKIE SNAPSHOT — Consent and analytics cookies
  // ─────────────────────────────────────────────────────────────────────────

  safe('cookies', () => {
    const allCookies = document.cookie.split(';').map(c => {
      const [name, ...rest] = c.trim().split('=');
      return { name: name.trim(), value: rest.join('=').trim() };
    });

    const CONSENT_COOKIES = ['truste_eu_v2', 'notice_gdpr_prefs', 'FCNEC', 'cmapi_cookie_privacy',
      'OptanonConsent', 'OptanonAlertBoxClosed', 'CookieConsent', 'euconsent-v2',
      'usprivacy', 'ccpa', 'didomi_token', 'osano_consentmanager'];
    const ANALYTICS_COOKIES = ['_ga', '_gid', '_gat', '_gcl_au', '_fbp', '_fbc', 'IDE',
      '_uetsid', '_uetvid', 'NID', 'SSID', '_clck', '_clsk', 'MUID', 'MR'];

    result.cookies = {
      total: allCookies.length,
      consentCookies: allCookies
        .filter(c => CONSENT_COOKIES.some(n => c.name.startsWith(n)))
        .map(c => ({ name: c.name, valuePreview: c.value.slice(0, 60) })),
      analyticsCookies: allCookies
        .filter(c => ANALYTICS_COOKIES.some(n => c.name === n || c.name.startsWith(n + '_')))
        .map(c => ({ name: c.name, valuePreview: c.value.slice(0, 30) })),
      // Flag if analytics cookies set without consent cookies (possible compliance gap)
      analyticsCookiesWithoutConsent: false // computed below
    };

    result.cookies.analyticsCookiesWithoutConsent =
      result.cookies.analyticsCookies.length > 0 &&
      result.cookies.consentCookies.length === 0;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 9. VENDOR GLOBAL DETECTION (window object fingerprinting)
  // ─────────────────────────────────────────────────────────────────────────

  safe('vendor_globals', () => {
    const VENDOR_GLOBALS = {
      // Analytics
      'GA4 / gtag': 'gtag',
      'Google Analytics (legacy ga)': 'ga',
      'Google Analytics (__gaTracker)': '__gaTracker',
      'Adobe Analytics (s)': 's',
      'Adobe AppMeasurement': 'AppMeasurement',
      'Heap': 'heap',
      'Amplitude': 'amplitude',
      'Mixpanel': 'mixpanel',
      'Segment': 'analytics',
      'FullStory': 'FS',
      'Hotjar': 'hj',
      'Microsoft Clarity': 'clarity',
      'Pendo': 'pendo',
      'Gainsight PX': 'aptrinsic',
      'PostHog': 'posthog',
      'Kissmetrics': '_kmq',
      'Woopra': 'woopra',
      // Advertising
      'Meta Pixel (fbq)': 'fbq',
      'Meta Pixel (FB)': '_fbq',
      'LinkedIn Insight': '_linkedin_partner_id',
      'Twitter/X Pixel': 'twq',
      'TikTok Pixel': 'ttq',
      'Pinterest Tag': 'pintrk',
      'Snapchat Pixel': 'snaptr',
      'Trade Desk': 'ttd_dom',
      'StackAdapt': 'saq',
      'AdRoll': '__adroll',
      'Criteo': 'criteo_q',
      'Taboola': '_taboola',
      'Outbrain': 'obApi',
      'Amazon Advertising': 'amzn_targs',
      // CDPs
      'mParticle': 'mParticle',
      'Tealium': 'utag',
      'Rudderstack': 'rudderanalytics',
      'Treasure Data': 'TD',
      'Lytics': 'jstag',
      // Marketing Automation
      'HubSpot': '_hsq',
      'Marketo Munchkin': 'Munchkin',
      'Pardot': 'piAId',
      'Intercom': 'Intercom',
      'Drift': 'drift',
      'Qualified': 'qualified',
      'Salesloft': 'SL',
      // Tag Managers
      'Google Tag Manager': 'google_tag_manager',
      'Adobe Launch': '_satellite',
      'Ensighten': 'Bootstrapper',
      'Commanders Act': 'tc_vars',
      // Monitoring / Error
      'New Relic': 'NREUM',
      'Dynatrace': 'dtrum',
      'Datadog RUM': 'DD_RUM',
      'Sentry': 'Sentry',
      'LogRocket': 'LogRocket',
      'Bugsnag': 'Bugsnag',
      // A/B Testing
      'Optimizely': 'optimizely',
      'VWO': 'VWO',
      'AB Tasty': 'ABTasty',
      'Google Optimize (legacy)': 'google_optimize',
      'LaunchDarkly': 'LDClient',
      // Video
      'YouTube Player API': 'YT',
      'Vimeo Player': 'Vimeo',
      'Wistia': 'Wistia',
      'Vidyard': 'VidyardV4',
      // Chat / Support
      'Zendesk Web Widget': 'zE',
      'LiveChat': 'LC_API',
      'Freshdesk': 'FreshworksWidget',
      // Session Recording (additional)
      'Mouseflow': 'mouseflow',
      'Mouseflow (_mfq)': '_mfq',
      'Lucky Orange': '__lo_cs_added',
      'Smartlook': 'smartlook',
      'Sprig': 'Sprig',
      // CRM / Marketing (additional)
      'HubSpot (_hsq)': '_hsq',
      'HubSpot (hbspt)': 'hbspt',
      'Salesforce Chat': 'embedded_svc',
      'CallRail': 'CallTrk',
      // Consent (additional)
      'CookiePro': 'OptanonWrapper',
      // Ecommerce
      'WooCommerce': 'wc_params',
      'WooCommerce (params)': 'woocommerce_params',
      'Shopify Analytics': 'ShopifyAnalytics',
    };

    const detected = {};
    Object.entries(VENDOR_GLOBALS).forEach(([name, global]) => {
      if (window[global] !== undefined) {
        detected[name] = { global, type: typeof window[global] };
      }
    });

    result.vendors.detected = detected;
    result.vendors.detectedCount = Object.keys(detected).length;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 10. GA4 / GOOGLE ADS ID EXTRACTION
  // ─────────────────────────────────────────────────────────────────────────

  safe('ga4_config', () => {
    const allContent = getAllScriptContent() + ' ' + window.location.href;
    const ga4 = {
      measurementIds: [...new Set((allContent.match(/G-[A-Z0-9]{8,12}/g) || []))],
      conversionIds: [...new Set((allContent.match(/AW-\d{7,12}/g) || []))],
      legacyUAIds: [...new Set((allContent.match(/UA-\d{5,12}-\d+/g) || []))],
      gtmContainerIds: [...new Set((allContent.match(/GTM-[A-Z0-9]+/g) || []))]
    };
    if (window.dataLayer) {
      const configCalls = window.dataLayer.filter(d =>
        Array.isArray(d) && d[0] === 'config' && typeof d[1] === 'string' && d[1].startsWith('G-')
      );
      ga4.configCalls = configCalls.length;
      ga4.potentialDuplicatePageViews = configCalls.length > 1;
    }
    result.gtm.ga4 = ga4;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 11. RESOURCE HINTS
  // ─────────────────────────────────────────────────────────────────────────

  safe('resource_hints', () => {
    const hints = Array.from(document.querySelectorAll('link[rel="preconnect"], link[rel="dns-prefetch"], link[rel="preload"], link[rel="prefetch"]'))
      .map(l => ({ rel: l.rel, href: l.href, as: l.as || null, crossOrigin: l.crossOrigin || null }));
    result.network.resourceHints = hints;
    result.network.resourceHintDomains = hints.map(h => {
      try { return new URL(h.href).hostname; } catch { return h.href; }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 12. FORM DETECTION (for GTM trigger scoping analysis)
  // ─────────────────────────────────────────────────────────────────────────

  safe('forms', () => {
    const forms = Array.from(document.querySelectorAll('form'));
    result.forms = {
      count: forms.length,
      types: {
        gravityForms: !!document.querySelector('.gform_wrapper, form[id^="gform_"]'),
        contactForm7: !!document.querySelector('.wpcf7-form'),
        wpForms: !!document.querySelector('.wpforms-form'),
        ninjaForms: !!document.querySelector('.nf-form-cont'),
        drupalWebform: !!document.querySelector('form.webform-submission-form'),
        formidable: !!document.querySelector('.frm-form-field'),
        pardot: !!document.querySelector('form[class*="pardot"]'),
        hubspotEmbed: !!document.querySelector('.hs-form'),
        marketo: !!document.querySelector('form.mktoForm')
      },
      formIds: forms.map(f => f.id || f.className?.slice?.(0, 40) || '(no id)').slice(0, 10)
    };
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 13. WORDPRESS / DRUPAL PLUGIN INVENTORY (from page source)
  // ─────────────────────────────────────────────────────────────────────────

  safe('plugin_inventory', () => {
    // WordPress: Detect plugins from wp-content/plugins/ paths in scripts, styles, and links
    const wpPlugins = new Set();
    const wpTheme = { name: null, version: null };

    document.querySelectorAll('script[src], link[href]').forEach(el => {
      const url = el.src || el.href || '';
      // Plugin detection
      const pluginMatch = url.match(/wp-content\/plugins\/([^/]+)\//);
      if (pluginMatch) wpPlugins.add(pluginMatch[1]);
      // Theme detection
      const themeMatch = url.match(/wp-content\/themes\/([^/]+)\//);
      if (themeMatch && !wpTheme.name) wpTheme.name = themeMatch[1];
    });

    // Also check meta generator for theme version
    const generatorMeta = document.querySelector('meta[name="generator"]');
    if (generatorMeta?.content?.includes('WordPress')) {
      const vMatch = generatorMeta.content.match(/WordPress ([\d.]+)/);
      if (vMatch) wpTheme.version = vMatch[1];
    }

    // GTM4WP specific version detection
    const gtm4wpScript = document.querySelector('script[src*="duracelltomi-google-tag-manager"], script[src*="gtm4wp"]');
    const gtm4wpVersion = gtm4wpScript?.src?.match(/ver=([\d.]+)/)?.[1] || null;

    // Drupal: Detect modules from paths
    const drupalModules = new Set();
    document.querySelectorAll('script[src], link[href]').forEach(el => {
      const url = el.src || el.href || '';
      const moduleMatch = url.match(/modules\/(?:contrib|custom)\/([^/]+)\//);
      if (moduleMatch) drupalModules.add(moduleMatch[1]);
    });

    result.cms.plugins = {
      wordpress: {
        detected: [...wpPlugins].sort(),
        pluginCount: wpPlugins.size,
        theme: wpTheme,
        gtm4wpVersion
      },
      drupal: {
        detected: [...drupalModules].sort(),
        moduleCount: drupalModules.size
      }
    };
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 14. SESSION RECORDER & VENDOR ID EXTRACTION (from page globals)
  // ─────────────────────────────────────────────────────────────────────────

  safe('vendor_ids', () => {
    const ids = {};

    // Hotjar site ID
    if (window.hj && window._hjSettings) {
      ids.hotjar = { siteId: window._hjSettings.hjid, version: window._hjSettings.hjsv };
    }

    // Mouseflow project ID
    if (window._mfq !== undefined || window.mouseflow) {
      ids.mouseflow = {
        projectId: window.mouseflowPath?.match(/([a-f0-9-]{36})/)?.[1] ||
                   document.querySelector('script[src*="mouseflow"]')?.src?.match(/([a-f0-9-]{36})/)?.[1] || null
      };
    }

    // Microsoft Clarity project ID
    if (window.clarity) {
      const clarityScript = document.querySelector('script[src*="clarity.ms"]');
      ids.clarity = {
        projectId: clarityScript?.src?.match(/[?&]t=([^&]+)/)?.[1] || null
      };
      // Also check inline scripts for clarity("set", ...)
      document.querySelectorAll('script:not([src])').forEach(s => {
        const m = s.textContent?.match(/clarity\s*\(\s*["']create["']\s*,\s*["']([^"']+)["']/);
        if (m) ids.clarity.projectId = m[1];
      });
    }

    // HubSpot portal ID
    if (window._hsq || window.hbspt) {
      const hsScript = document.querySelector('script[src*="hs-scripts.net"], script[src*="hsforms.net"]');
      ids.hubspot = {
        portalId: hsScript?.src?.match(/\/(\d+)\//)?.[1] ||
                  window.hbspt?.forms?.portalId || null,
        formsLoaded: !!window.hbspt?.forms,
        chatLoaded: !!window.HubSpotConversations
      };
    }

    // FullStory org ID
    if (window.FS) {
      ids.fullstory = { orgId: window._fs_org || null };
    }

    // Pendo app key
    if (window.pendo) {
      ids.pendo = { appKey: window.pendo?.apiKey || null };
    }

    result.vendors.ids = ids;
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 15. ASYNC: GTM CONTAINER SOURCE FETCH + ANALYSIS
  //     Fetches the live GTM container JS to analyze its structure in-band,
  //     eliminating the need for a separate Bash curl call.
  // ─────────────────────────────────────────────────────────────────────────

  await safeAsync('gtm_container_fetch', async () => {
    const containerIds = result.gtm?.containerIds || [];
    if (!containerIds.length) return;

    const containerId = containerIds[0];
    const containerUrl = `https://www.googletagmanager.com/gtm.js?id=${containerId}`;

    const response = await fetch(containerUrl, {
      cache: 'no-store',
      headers: { 'Accept-Encoding': 'gzip' }
    });

    if (!response.ok) {
      result.gtm.containerFetchError = `HTTP ${response.status}`;
      return;
    }

    const text = await response.text();
    const gzipEstimate = Math.round(text.length * 0.28); // rough gzip estimate

    // Tag type counts from GTM's compiled container format
    // These are GTM internal tag type identifiers used in the compiled JS
    const tagTypes = {
      customHtml:       (text.match(/__html/g) || []).length,
      ga4Events:        (text.match(/__gaawe/g) || []).length,
      ga4Config:        (text.match(/__googtag/g) || []).length,
      googleAdsConvert: (text.match(/__awct/g) || []).length,
      googleAdsRemk:    (text.match(/__remm/g) || []).length,
      legacyUA:         (text.match(/__ua\b/g) || []).length,
      legacyUASettings: (text.match(/__gas/g) || []).length,
      hotjar:           (text.match(/__hjtc/g) || []).length,
      mouseflow:        (text.match(/__mf\b/g) || []).length,
      gclidWorker:      (text.match(/__gclidw/g) || []).length,
      linkedinInsight:  (text.match(/__bzi/g) || []).length,
      floodlight:       (text.match(/__fls/g) || []).length,
      conversionLinker: (text.match(/__cl\b/g) || []).length,
      googleOptimize:   (text.match(/__opt/g) || []).length,
      metaPixel:        (text.match(/__fbp/g) || []).length,
      twitterPixel:     (text.match(/__twitter/g) || []).length,
      pinterestTag:     (text.match(/__pin/g) || []).length,
      paused:           (text.match(/__paused/g) || []).length,
      functionDirs:     (text.match(/__function/g) || []).length,
      variables:        (text.match(/__v\b/g) || []).length,
      triggers:         (text.match(/__t\b/g) || []).length,
    };

    // Unique tag IDs
    const tagIds = [...new Set((text.match(/tag_id:\s*(\d+)/g) || []).map(m => m.match(/\d+/)[0]))];

    // Extract all IDs from container source
    const ga4Ids = [...new Set((text.match(/G-[A-Z0-9]{8,12}/g) || []))];
    const uaIds = [...new Set((text.match(/UA-\d{5,12}-\d+/g) || []))];
    const adsIds = [...new Set((text.match(/AW-\d{7,12}/g) || []))];

    // Detect known problematic patterns in container
    const patterns = {
      hasSetInterval:      text.includes('setInterval'),
      hasDocumentWrite:    text.includes('document.write'),
      hasEval:             text.includes('eval('),
      hasInlineScript:     (text.match(/vtp_html:/g) || []).length,   // Custom HTML tag count
      asyncScriptCreate:   text.includes('script.async'),             // async script creation
      syncScriptCreate:    text.includes("script.type = 'text/javascript'") && !text.includes('script.async'),
      hasFbevents:         text.includes('fbevents.js'),
      hasLiveRamp:         text.includes('rlcdn') || text.includes('LiveConnect') || text.includes('_lrx'),
      hasStackAdapt:       text.includes('stackadapt'),
      hasAdRoll:           text.includes('adroll'),
      hasTradeDesk:        text.includes('adsrvr'),
      hasSpotify:          text.includes('byspotify'),
      hasMagellan:         text.includes('mgln.ai'),
      hasVeritone:         text.includes('veritone'),
      hasMouseflow:        text.includes('mouseflow'),
      hasHotjar:           text.includes('hotjar'),
      hasClarity:          text.includes('clarity'),
      hasCookiePro:        text.includes('cookiepro') || text.includes('optanon'),
      hasHubSpot:          text.includes('hsforms') || text.includes('hs-scripts'),
    };

    // Vendor-specific IDs extracted from container source
    const vendorIds = {
      hotjarSiteIds: [...new Set((text.match(/(?:h\.hjSiteSettings|hj\.id)\s*=\s*(\d+)/g) || []).map(m => m.match(/\d+/)?.[0]).filter(Boolean))],
      mouseflowIds: [...new Set((text.match(/['"]([\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12})['"]/g) || [])
        .map(m => m.replace(/['"]/g, '')))].slice(0, 3),
      clarityIds: [...new Set((text.match(/clarity['"]\s*,\s*['"]([\w]+)['"]/g) || []).map(m => m.match(/['"]([\w]+)['"]$/)?.[1]).filter(Boolean))],
      hubspotPortalIds: [...new Set((text.match(/(?:hs-scripts|hsforms)\.net\/(?:hub\/)?(\d+)/g) || []).map(m => m.match(/(\d+)/)?.[1]).filter(Boolean))],
    };

    // Custom HTML tag content snippets (vtp_html values — up to 10)
    const htmlTagSnippets = [];
    const htmlMatches = text.matchAll(/vtp_html:"((?:[^"\\]|\\.)*)"/g);
    for (const m of htmlMatches) {
      const decoded = m[1].replace(/\\n/g, '\n').replace(/\\"/g, '"').replace(/\\t/g, ' ').slice(0, 300);
      htmlTagSnippets.push(decoded);
      if (htmlTagSnippets.length >= 12) break;
    }

    result.gtm.containerSource = {
      url: containerUrl,
      sizeBytes: text.length,
      gzipEstimate,
      tagTypes,
      uniqueTagIds: tagIds.length,
      ga4Ids,
      uaIds,
      adsIds,
      vendorIds,
      patterns,
      customHtmlSnippets: htmlTagSnippets
    };
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 16. SUMMARY
  // ─────────────────────────────────────────────────────────────────────────

  safe('summary', () => {
    const s = result.scripts;
    const n = result.network;
    const p = result.performance;
    const c = result.consent;
    const g = result.gtm;
    const cs = g.containerSource;

    result.summary = {
      gtmPresent: g.present || false,
      containerIds: g.containerIds || [],
      containerSizeKb: cs ? Math.round(cs.sizeBytes / 1024) : null,
      containerGzipKb: cs ? Math.round(cs.gzipEstimate / 1024) : null,
      uniqueTagCount: cs?.uniqueTagIds || null,
      customHtmlTagCount: cs?.tagTypes?.customHtml || null,
      ga4EventTagCount: cs?.tagTypes?.ga4Events || null,
      hasDuplicateGA4: g.ga4?.potentialDuplicatePageViews || false,
      legacyUAPresent: (g.ga4?.legacyUAIds || []).length > 0,
      blockingHeadScriptCount: s.blockingHeadCount || 0,
      totalHeadInlineSizeKb: Math.round((s.totalHeadInlineSize || 0) / 1024),
      thirdPartyTrackingCount: n.totalThirdPartyCount || 0,
      thirdPartyDomainCount: (n.uniqueThirdPartyDomains || []).length,
      totalThirdPartyKb: Math.round((n.totalThirdPartyBytes || 0) / 1024),
      consentModeV2: c.googleConsentMode?.v2Defaults || false,
      analyticsCookiesWithoutConsent: result.cookies?.analyticsCookiesWithoutConsent || false,
      lcpMs: p.cwv?.lcp?.value || null,
      lcpRating: p.cwv?.lcp?.rating || null,
      clsValue: p.cwv?.cls?.value || null,
      inpMs: p.cwv?.inp_estimate?.value || null,
      ttfbMs: p.navigation?.ttfb || null,
      longTaskCount: p.longTasks?.count || 0,
      totalBlockingTimeMs: p.longTasks?.totalBlockingTime || 0,
      vendorsDetectedCount: result.vendors.detectedCount || 0,
      hasSetIntervalInContainer: cs?.patterns?.hasSetInterval || false,
      cmsDetected: result.cms?.drupal?.present ? 'Drupal' :
                   result.cms?.wordpress?.present ? 'WordPress' :
                   result.cms?.shopify?.present ? 'Shopify' : 'Unknown',
      formLibrariesDetected: Object.entries(result.forms?.types || {})
        .filter(([, v]) => v).map(([k]) => k),
      wpPluginCount: result.cms?.plugins?.wordpress?.pluginCount || 0,
      wpTheme: result.cms?.plugins?.wordpress?.theme?.name || null,
      gtm4wpVersion: result.cms?.plugins?.wordpress?.gtm4wpVersion || null,
      sessionRecorders: Object.keys(result.vendors?.ids || {}).filter(k =>
        ['hotjar', 'mouseflow', 'clarity', 'fullstory'].includes(k)),
      hubspotPortalId: result.vendors?.ids?.hubspot?.portalId || null,
      errors: result.errors
    };
  });

  return result;
}
