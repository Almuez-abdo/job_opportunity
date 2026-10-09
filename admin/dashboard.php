<?php
/**
 * Admin Panel - Dashboard
 */
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/functions.php';
require_login();

// Get statistics
$stats = [];

try {
    $stmt = $pdo->query("SELECT COUNT(*) FROM contact_messages");
    $stats['total_messages'] = $stmt->fetchColumn();
    
    $stmt = $pdo->query("SELECT COUNT(*) FROM contact_messages WHERE status = 'new'");
    $stats['new_messages'] = $stmt->fetchColumn();
    
    $stmt = $pdo->query("SELECT COUNT(*) FROM projects");
    $stats['total_projects'] = $stmt->fetchColumn();
    
    $stmt = $pdo->query("SELECT COUNT(*) FROM services");
    $stats['total_services'] = $stmt->fetchColumn();
    
    $stmt = $pdo->query("SELECT * FROM contact_messages ORDER BY created_at DESC LIMIT 5");
    $recent_messages = $stmt->fetchAll();
} catch (PDOException $e) {
    $stats = ['total_messages' => 0, 'new_messages' => 0, 'total_projects' => 0, 'total_services' => 0];
    $recent_messages = [];
}
?>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - <?= SITE_NAME ?> Admin</title>
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
                <a class="nav-link active" href="dashboard.php"><i class="bi bi-speedometer2"></i> Dashboard</a>
                <a class="nav-link" href="messages.php"><i class="bi bi-envelope"></i> Messages <?php if ($stats['new_messages'] > 0): ?><span class="badge bg-danger ms-auto"><?= $stats['new_messages'] ?></span><?php endif; ?></a>
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
                    <h2>Dashboard</h2>
                    <p style="color: #7a7a9e; margin: 0;">Welcome back, <?= sanitize($_SESSION['admin_username'] ?? 'Admin') ?></p>
                </div>
                <button class="btn btn-outline-light d-lg-none" onclick="document.getElementById('sidebar').classList.toggle('show')">
                    <i class="bi bi-list"></i>
                </button>
            </div>

            <!-- Stats Cards -->
            <div class="row g-4 mb-4">
                <div class="col-xl-3 col-md-6">
                    <div class="admin-stat-card">
                        <div class="stat-icon" style="background: rgba(0, 206, 201, 0.15); color: #00cec9;">
                            <i class="bi bi-envelope"></i>
                        </div>
                        <h3><?= $stats['total_messages'] ?></h3>
                        <p>Total Messages</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="admin-stat-card">
                        <div class="stat-icon" style="background: rgba(108, 92, 231, 0.15); color: #6c5ce7;">
                            <i class="bi bi-envelope-plus"></i>
                        </div>
                        <h3><?= $stats['new_messages'] ?></h3>
                        <p>New Messages</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="admin-stat-card">
                        <div class="stat-icon" style="background: rgba(0, 184, 148, 0.15); color: #00b894;">
                            <i class="bi bi-folder"></i>
                        </div>
                        <h3><?= $stats['total_projects'] ?></h3>
                        <p>Total Projects</p>
                    </div>
                </div>
                <div class="col-xl-3 col-md-6">
                    <div class="admin-stat-card">
                        <div class="stat-icon" style="background: rgba(253, 203, 110, 0.15); color: #fdcb6e;">
                            <i class="bi bi-gear"></i>
                        </div>
                        <h3><?= $stats['total_services'] ?></h3>
                        <p>Total Services</p>
                    </div>
                </div>
            </div>

            <!-- Recent Messages -->
            <div class="admin-table">
                <div style="padding: 20px; border-bottom: 1px solid rgba(108, 92, 231, 0.1);">
                    <h4 style="color: #fff; font-size: 1.1rem; font-weight: 700; margin: 0;">Recent Messages</h4>
                </div>
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($recent_messages)): ?>
                                <?php foreach ($recent_messages as $msg): ?>
                                    <tr>
                                        <td><?= sanitize($msg['name']) ?></td>
                                        <td><?= sanitize($msg['subject']) ?></td>
                                        <td><?= date('M d, Y', strtotime($msg['created_at'])) ?></td>
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
                                            <a href="messages.php?view=<?= $msg['id'] ?>" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #7a7a9e; padding: 30px;">No messages yet.</td>
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
