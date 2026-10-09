<?php
/**
 * Admin Panel - Messages Management
 */
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/functions.php';
require_login();

$message = '';
$msg_type = '';

// Handle actions
if (isset($_GET['action']) && isset($_GET['id'])) {
    $id = (int)$_GET['id'];
    
    if ($_GET['action'] === 'read') {
        $stmt = $pdo->prepare("UPDATE contact_messages SET status = 'read' WHERE id = ?");
        $stmt->execute([$id]);
        $message = 'Message marked as read.';
        $msg_type = 'success';
    } elseif ($_GET['action'] === 'replied') {
        $stmt = $pdo->prepare("UPDATE contact_messages SET status = 'replied' WHERE id = ?");
        $stmt->execute([$id]);
        $message = 'Message marked as replied.';
        $msg_type = 'success';
    } elseif ($_GET['action'] === 'delete') {
        $stmt = $pdo->prepare("DELETE FROM contact_messages WHERE id = ?");
        $stmt->execute([$id]);
        $message = 'Message deleted.';
        $msg_type = 'success';
    }
}

// View single message
$view_msg = null;
if (isset($_GET['view'])) {
    $stmt = $pdo->prepare("SELECT * FROM contact_messages WHERE id = ?");
    $stmt->execute([(int)$_GET['view']]);
    $view_msg = $stmt->fetch();
    if ($view_msg && $view_msg['status'] === 'new') {
        $stmt2 = $pdo->prepare("UPDATE contact_messages SET status = 'read' WHERE id = ?");
        $stmt2->execute([$view_msg['id']]);
        $view_msg['status'] = 'read';
    }
}

// Fetch all messages
$stmt = $pdo->query("SELECT * FROM contact_messages ORDER BY created_at DESC");
$messages = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - <?= SITE_NAME ?> Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="../assets/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="admin-wrapper">
        <!-- Sidebar -->
        <div class="admin-sidebar" id="sidebar">
            <div class="sidebar-brand">
                <h4>Elmuez<span>Abd Alla</span></h4>
                <small style="color: #7a7a9e;">Admin Panel</small>
            </div>
            <nav class="nav flex-column">
                <a class="nav-link" href="dashboard.php"><i class="bi bi-speedometer2"></i> Dashboard</a>
                <a class="nav-link active" href="messages.php"><i class="bi bi-envelope"></i> Messages</a>
                <a class="nav-link" href="projects.php"><i class="bi bi-folder"></i> Projects</a>
                <a class="nav-link" href="services-admin.php"><i class="bi bi-gear"></i> Services</a>
                <a class="nav-link" href="../index.php" target="_blank"><i class="bi bi-globe"></i> View Website</a>
                <a class="nav-link mt-4" href="logout.php"><i class="bi bi-box-arrow-left"></i> Logout</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div>
                    <h2><i class="bi bi-envelope me-2"></i>Contact Messages</h2>
                </div>
                <button class="btn btn-outline-light d-lg-none" onclick="document.getElementById('sidebar').classList.toggle('show')">
                    <i class="bi bi-list"></i>
                </button>
            </div>

            <?php if (!empty($message)): ?>
                <div class="alert alert-<?= $msg_type === 'success' ? 'success' : 'danger' ?> alert-dismissible fade show" style="background: <?= $msg_type === 'success' ? 'rgba(0,184,148,0.15)' : 'rgba(214,48,49,0.15)' ?>; border: 1px solid <?= $msg_type === 'success' ? 'rgba(0,184,148,0.3)' : 'rgba(214,48,49,0.3)' ?>; color: <?= $msg_type === 'success' ? '#00b894' : '#ff6b6b' ?>;">
                    <?= $message ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>

            <?php if ($view_msg): ?>
                <!-- View Message Modal -->
                <div class="admin-form mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 style="color: #fff; font-weight: 700; margin: 0;">
                            <i class="bi bi-envelope-open me-2"></i>Message Details
                        </h4>
                        <a href="messages.php" class="btn btn-sm btn-outline-light">
                            <i class="bi bi-x-lg"></i> Close
                        </a>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">From:</small>
                            <p style="color: #fff; font-weight: 600;"><?= sanitize($view_msg['name']) ?></p>
                        </div>
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">Email:</small>
                            <p style="color: #fff; font-weight: 600;"><?= sanitize($view_msg['email']) ?></p>
                        </div>
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">Phone:</small>
                            <p style="color: #fff; font-weight: 600;"><?= sanitize($view_msg['phone'] ?: 'Not provided') ?></p>
                        </div>
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">Service:</small>
                            <p style="color: #fff; font-weight: 600;"><?= sanitize($view_msg['service'] ?: 'Not specified') ?></p>
                        </div>
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">Subject:</small>
                            <p style="color: #fff; font-weight: 600;"><?= sanitize($view_msg['subject']) ?></p>
                        </div>
                        <div class="col-md-6">
                            <small style="color: #7a7a9e;">Date:</small>
                            <p style="color: #fff; font-weight: 600;"><?= date('M d, Y h:i A', strtotime($view_msg['created_at'])) ?></p>
                        </div>
                    </div>
                    <div>
                        <small style="color: #7a7a9e;">Message:</small>
                        <p style="color: #ddd; line-height: 1.8; background: #222255; padding: 15px; border-radius: 8px;"><?= nl2br(sanitize($view_msg['message'])) ?></p>
                    </div>
                    <div class="d-flex gap-2 mt-3">
                        <?php if ($view_msg['status'] !== 'replied'): ?>
                            <a href="?action=replied&id=<?= $view_msg['id'] ?>" class="btn btn-sm" style="background: rgba(0,184,148,0.2); color: #00b894; border: 1px solid rgba(0,184,148,0.3);">
                                <i class="bi bi-check-circle me-1"></i>Mark as Replied
                            </a>
                        <?php endif; ?>
                        <a href="?action=delete&id=<?= $view_msg['id'] ?>" class="btn btn-sm" style="background: rgba(214,48,49,0.2); color: #ff6b6b; border: 1px solid rgba(214,48,49,0.3);" onclick="return confirm('Delete this message?')">
                            <i class="bi bi-trash me-1"></i>Delete
                        </a>
                    </div>
                </div>
            <?php endif; ?>

            <!-- Messages Table -->
            <div class="admin-table">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Subject</th>
                                <th>Service</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($messages)): ?>
                                <?php foreach ($messages as $i => $msg): ?>
                                    <tr>
                                        <td><?= $i + 1 ?></td>
                                        <td><?= sanitize($msg['name']) ?></td>
                                        <td><small><?= sanitize($msg['email']) ?></small></td>
                                        <td><?= sanitize($msg['subject']) ?></td>
                                        <td><small><?= sanitize($msg['service'] ?: '-') ?></small></td>
                                        <td><small><?= date('M d, Y', strtotime($msg['created_at'])) ?></small></td>
                                        <td>
                                            <?php if ($msg['status'] === 'new'): ?>
                                                <span class="badge-new">New</span>
                                            <?php elseif ($msg['status'] === 'read'): ?>
                                                <span class="badge-read">Read</span>
                                            <?php else: ?>
                                                <span class="badge-replied">Replied</span>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-1">
                                                <a href="?view=<?= $msg['id'] ?>" class="btn btn-sm btn-outline-primary" title="View"><i class="bi bi-eye"></i></a>
                                                <?php if ($msg['status'] === 'new'): ?>
                                                    <a href="?action=read&id=<?= $msg['id'] ?>" class="btn btn-sm btn-outline-secondary" title="Mark Read"><i class="bi bi-check-lg"></i></a>
                                                <?php endif; ?>
                                                <a href="?action=delete&id=<?= $msg['id'] ?>" class="btn btn-sm btn-outline-danger" title="Delete" onclick="return confirm('Delete this message?')"><i class="bi bi-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="8" style="text-align: center; color: #7a7a9e; padding: 40px;">No messages found.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
