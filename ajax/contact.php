<?php
/**
 * AJAX Contact Form Handler
 */

header('Content-Type: application/json');

require_once __DIR__ . '/../includes/functions.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
    exit;
}

// Anti-spam: honeypot field
if (!empty($_POST['website'])) {
    echo json_encode(['success' => true, 'message' => 'Thank you for your message!']);
    exit;
}

$name = trim($_POST['name'] ?? '');
$email = trim($_POST['email'] ?? '');
$phone = trim($_POST['phone'] ?? '');
$subject = trim($_POST['subject'] ?? '');
$service = trim($_POST['service'] ?? '');
$message = trim($_POST['message'] ?? '');

// Validation
$errors = [];

if (empty($name) || strlen($name) < 2) {
    $errors[] = 'Please enter your name (at least 2 characters).';
}

if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $errors[] = 'Please enter a valid email address.';
}

if (empty($subject) || strlen($subject) < 3) {
    $errors[] = 'Please enter a subject.';
}

if (empty($message) || strlen($message) < 10) {
    $errors[] = 'Please enter your message (at least 10 characters).';
}

if (!empty($errors)) {
    echo json_encode(['success' => false, 'message' => implode(' ', $errors)]);
    exit;
}

// Rate limiting (simple: max 5 messages per IP per hour)
$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$stmt = $pdo->prepare("SELECT COUNT(*) FROM contact_messages WHERE ip_address = ? AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)");
$stmt->execute([$ip]);
$count = $stmt->fetchColumn();

if ($count >= 5) {
    echo json_encode(['success' => false, 'message' => 'Too many messages. Please try again later.']);
    exit;
}

// Sanitize
$name = sanitize($name);
$email = sanitize($email);
$phone = sanitize($phone);
$subject = sanitize($subject);
$service = sanitize($service);
$message = sanitize($message);

// Insert
try {
    $stmt = $pdo->prepare("INSERT INTO contact_messages (name, email, phone, subject, service, message, ip_address) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([$name, $email, $phone, $subject, $service, $message, $ip]);
    
    echo json_encode(['success' => true, 'message' => 'Your message has been sent successfully! I will get back to you soon.']);
} catch (PDOException $e) {
    error_log("Contact form error: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'An error occurred. Please try again later.']);
}
