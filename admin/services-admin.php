<?php
/**
 * Admin Panel - Services Management
 */
session_start();
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/functions.php';
require_login();

$message = '';
$msg_type = '';

// Handle form submissions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'add' || $action === 'edit') {
        $title = trim($_POST['title'] ?? '');
        $description = trim($_POST['description'] ?? '');
        $icon = trim($_POST['icon'] ?? 'bi-gear');
        $sort_order = (int)($_POST['sort_order'] ?? 0);
        
        if (empty($title) || empty($description)) {
            $message = 'Title and description are required.';
            $msg_type = 'danger';
        } else {
            if ($action === 'add') {
                $stmt = $pdo->prepare("INSERT INTO services (title, description, icon, sort_order) VALUES (?, ?, ?, ?)");
                $stmt->execute([$title, $description, $icon, $sort_order]);
                $message = 'Service added successfully!';
                $msg_type = 'success';
            } else {
                $id = (int)$_POST['id'];
                $stmt = $pdo->prepare("UPDATE services SET title=?, description=?, icon=?, sort_order=? WHERE id=?");
                $stmt->execute([$title, $description, $icon, $sort_order, $id]);
                $message = 'Service updated successfully!';
                $msg_type = 'success';
            }
        }
    } elseif ($action === 'delete') {
        $id = (int)$_POST['id'];
        $stmt = $pdo->prepare("DELETE FROM services WHERE id = ?");
        $stmt->execute([$id]);
        $message = 'Service deleted.';
        $msg_type = 'success';
    }
}

// Handle delete via GET
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $stmt = $pdo->prepare("DELETE FROM services WHERE id = ?");
    $stmt->execute([$id]);
    $message = 'Service deleted.';
    $msg_type = 'success';
}

// Fetch services
$services = $pdo->query("SELECT * FROM services ORDER BY sort_order ASC, id ASC")->fetchAll();

// Fetch single service for editing
$edit_service = null;
if (isset($_GET['edit'])) {
    $stmt = $pdo->prepare("SELECT * FROM services WHERE id = ?");
    $stmt->execute([(int)$_GET['edit']]);
    $edit_service = $stmt->fetch();
}
?>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Services - <?= SITE_NAME ?> Admin</title>
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
                <a class="nav-link" href="messages.php"><i class="bi bi-envelope"></i> Messages</a>
                <a class="nav-link" href="projects.php"><i class="bi bi-folder"></i> Projects</a>
                <a class="nav-link active" href="services-admin.php"><i class="bi bi-gear"></i> Services</a>
                <a class="nav-link" href="../index.php" target="_blank"><i class="bi bi-globe"></i> View Website</a>
                <a class="nav-link mt-4" href="logout.php"><i class="bi bi-box-arrow-left"></i> Logout</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div>
                    <h2><i class="bi bi-gear me-2"></i>Services Management</h2>
                </div>
                <button class="btn btn-outline-light d-lg-none" onclick="document.getElementById('sidebar').classList.toggle('show')">
                    <i class="bi bi-list"></i>
                </button>
            </div>

            <?php if (!empty($message)): ?>
                <div class="alert alert-<?= $msg_type ?> alert-dismissible fade show" style="background: <?= $msg_type === 'success' ? 'rgba(0,184,148,0.15)' : 'rgba(214,48,49,0.15)' ?>; border: 1px solid <?= $msg_type === 'success' ? 'rgba(0,184,148,0.3)' : 'rgba(214,48,49,0.3)' ?>; color: <?= $msg_type === 'success' ? '#00b894' : '#ff6b6b' ?>;">
                    <?= $message ?>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>

            <!-- Add/Edit Form -->
            <div class="admin-form mb-4">
                <h4 style="color: #fff; font-weight: 700; margin-bottom: 20px;">
                    <i class="bi <?= $edit_service ? 'bi-pencil' : 'bi-plus-circle' ?> me-2"></i>
                    <?= $edit_service ? 'Edit Service' : 'Add New Service' ?>
                </h4>
                <form method="POST">
                    <input type="hidden" name="action" value="<?= $edit_service ? 'edit' : 'add' ?>">
                    <?php if ($edit_service): ?>
                        <input type="hidden" name="id" value="<?= $edit_service['id'] ?>">
                    <?php endif; ?>
                    
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label">Service Title *</label>
                            <input type="text" class="form-control" name="title" required value="<?= sanitize($edit_service['title'] ?? '') ?>">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Icon (Bootstrap Icon class)</label>
                            <input type="text" class="form-control" name="icon" value="<?= sanitize($edit_service['icon'] ?? 'bi-gear') ?>" placeholder="bi-gear">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Sort Order</label>
                            <input type="number" class="form-control" name="sort_order" value="<?= $edit_service['sort_order'] ?? 0 ?>">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-lg me-1"></i><?= $edit_service ? 'Update' : 'Add' ?>
                            </button>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description *</label>
                            <textarea class="form-control" name="description" rows="3" required><?= sanitize($edit_service['description'] ?? '') ?></textarea>
                        </div>
                    </div>
                    
                    <?php if ($edit_service): ?>
                        <div class="mt-3">
                            <a href="services-admin.php" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-x-lg me-1"></i>Cancel Edit
                            </a>
                        </div>
                    <?php endif; ?>
                </form>
            </div>

            <!-- Services Table -->
            <div class="admin-table">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Icon</th>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Order</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($services)): ?>
                                <?php foreach ($services as $i => $svc): ?>
                                    <tr>
                                        <td><?= $i + 1 ?></td>
                                        <td><i class="bi <?= sanitize($svc['icon']) ?>" style="font-size: 1.3rem; color: #6c5ce7;"></i></td>
                                        <td style="color: #fff; font-weight: 600;"><?= sanitize($svc['title']) ?></td>
                                        <td><small style="color: #7a7a9e;"><?= sanitize(substr($svc['description'], 0, 80)) ?>...</small></td>
                                        <td><?= $svc['sort_order'] ?></td>
                                        <td>
                                            <div class="d-flex gap-1">
                                                <a href="?edit=<?= $svc['id'] ?>" class="btn btn-sm btn-outline-primary" title="Edit"><i class="bi bi-pencil"></i></a>
                                                <a href="?delete=<?= $svc['id'] ?>" class="btn btn-sm btn-outline-danger" title="Delete" onclick="return confirm('Delete this service?')"><i class="bi bi-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #7a7a9e; padding: 40px;">No services yet.</td>
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
