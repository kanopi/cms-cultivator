# Security Scanner — Vulnerability Patterns Reference

Reference file for the security-scanner skill. Contains before/after code examples for common vulnerability categories in Drupal and WordPress.

---

## Quick Security Checks

### 1. SQL Injection

**Vulnerable Pattern:**
```php
// ❌ DANGEROUS
$query = "SELECT * FROM users WHERE id = " . $_GET['id'];
db_query($query);
```

**Secure Pattern:**
```php
// ✅ SECURE
$query = db_select('users', 'u')
  ->condition('id', $id, '=')
  ->execute();

// Or with placeholders
$query = "SELECT * FROM users WHERE id = :id";
db_query($query, [':id' => $id]);
```

### 2. Cross-Site Scripting (XSS)

**Vulnerable Pattern:**
```php
// ❌ DANGEROUS
echo "<div>" . $_POST['name'] . "</div>";
```

**Secure Pattern:**
```php
// ✅ SECURE (Drupal)
echo "<div>" . Html::escape($_POST['name']) . "</div>";

// ✅ SECURE (WordPress)
echo "<div>" . esc_html( $_POST['name'] ) . "</div>";
```

### 3. CSRF (Cross-Site Request Forgery)

**Vulnerable Pattern:**
```php
// ❌ DANGEROUS - No CSRF protection
if ($_POST['action'] === 'delete') {
  delete_user($_POST['user_id']);
}
```

**Secure Pattern:**
```php
// ✅ SECURE (Drupal) - CSRF token validation
if ($_POST['form_token'] && \Drupal::csrfToken()->validate($_POST['form_token'])) {
  delete_user($_POST['user_id']);
}

// ✅ SECURE (WordPress) - Nonce validation
if (wp_verify_nonce($_POST['_wpnonce'], 'delete_user')) {
  delete_user($_POST['user_id']);
}
```

### 4. Authentication Bypass

**Check for:**
- Missing permission checks
- Hardcoded credentials
- Weak password requirements
- Session fixation vulnerabilities

### 5. File Upload Vulnerabilities

**Vulnerable Pattern:**
```php
// ❌ DANGEROUS - No validation
move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $_FILES['file']['name']);
```

**Secure Pattern:**
```php
// ✅ SECURE
$allowed_types = ['jpg', 'png', 'pdf'];
$extension = pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION);

if (in_array(strtolower($extension), $allowed_types)) {
  $safe_name = preg_replace('/[^a-zA-Z0-9_-]/', '', basename($_FILES['file']['name']));
  move_uploaded_file($_FILES['file']['tmp_name'], 'uploads/' . $safe_name);
}
```

---

## Common Vulnerabilities

### Input Validation
```php
// ❌ No validation
$age = $_POST['age'];

// ✅ Validated
$age = filter_var($_POST['age'], FILTER_VALIDATE_INT, [
  'options' => ['min_range' => 1, 'max_range' => 120]
]);
```

### Output Escaping
```php
// ❌ Unescaped
echo $user_input;

// ✅ Escaped (context-appropriate)
echo Html::escape($user_input);           // HTML context
echo Html::escape($user_input, ENT_QUOTES); // Attribute context
echo json_encode($user_input);            // JSON context
```

### Access Control
```php
// ❌ No permission check
function deleteUser($uid) {
  User::load($uid)->delete();
}

// ✅ Permission checked
function deleteUser($uid) {
  if (!\Drupal::currentUser()->hasPermission('delete users')) {
    throw new AccessDeniedHttpException();
  }
  User::load($uid)->delete();
}
```
