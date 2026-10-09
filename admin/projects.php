<?php
/**
 * Admin Panel - Projects Management
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
        $category = trim($_POST['category'] ?? '');
        $technologies = trim($_POST['technologies'] ?? '');
        $live_url = trim($_POST['live_url'] ?? '#');
        $github_url = trim($_POST['github_url'] ?? '#');
        $sort_order = (int)($_POST['sort_order'] ?? 0);
        
        if (empty($title) || empty($description) || empty($category)) {
            $message = 'Title, description, and category are required.';
            $msg_type = 'danger';
        } else {
            // Handle image upload
            $image_path = $_POST['existing_image'] ?? '';
            if (!empty($_FILES['image']['name'])) {
                $upload = upload_image($_FILES['image'], '../assets/uploads/');
                if ($upload['success']) {
                    $image_path = $upload['filename'];
                } else {
                    $message = $upload['message'];
                    $msg_type = 'danger';
                }
            }
            
            if ($msg_type !== 'danger') {
                if ($action === 'add') {
                    $stmt = $pdo->prepare("INSERT INTO projects (title, description, category, technologies, image, live_url, github_url, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                    $stmt->execute([$title, $description, $category, $technologies, $image_path, $live_url, $github_url, $sort_order]);
                    $message = 'Project added successfully!';
                    $msg_type = 'success';
                } else {
                    $id = (int)$_POST['id'];
                    $stmt = $pdo->prepare("UPDATE projects SET title=?, description=?, category=?, technologies=?, image=?, live_url=?, github_url=?, sort_order=? WHERE id=?");
                    $stmt->execute([$title, $description, $category, $technologies, $image_path, $live_url, $github_url, $sort_order, $id]);
                    $message = 'Project updated successfully!';
                    $msg_type = 'success';
                }
            }
        }
    } elseif ($action === 'delete') {
        $id = (int)$_POST['id'];
        $stmt = $pdo->prepare("DELETE FROM projects WHERE id = ?");
        $stmt->execute([$id]);
        $message = 'Project deleted.';
        $msg_type = 'success';
    }
}

// Handle delete via GET
if (isset($_GET['delete'])) {
    $id = (int)$_GET['delete'];
    $stmt = $pdo->prepare("DELETE FROM projects WHERE id = ?");
    $stmt->execute([$id]);
    $message = 'Project deleted.';
    $msg_type = 'success';
}

// Fetch projects
$projects = $pdo->query("SELECT * FROM projects ORDER BY sort_order ASC, id DESC")->fetchAll();

// Fetch single project for editing
$edit_project = null;
if (isset($_GET['edit'])) {
    $stmt = $pdo->prepare("SELECT * FROM projects WHERE id = ?");
    $stmt->execute([(int)$_GET['edit']]);
    $edit_project = $stmt->fetch();
}
?>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Projects - <?= SITE_NAME ?> Admin</title>
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
                <a class="nav-link active" href="projects.php"><i class="bi bi-folder"></i> Projects</a>
                <a class="nav-link" href="services-admin.php"><i class="bi bi-gear"></i> Services</a>
                <a class="nav-link" href="../index.php" target="_blank"><i class="bi bi-globe"></i> View Website</a>
                <a class="nav-link mt-4" href="logout.php"><i class="bi bi-box-arrow-left"></i> Logout</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="admin-content">
            <div class="admin-header">
                <div>
                    <h2><i class="bi bi-folder me-2"></i>Projects Management</h2>
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
                    <i class="bi <?= $edit_project ? 'bi-pencil' : 'bi-plus-circle' ?> me-2"></i>
                    <?= $edit_project ? 'Edit Project' : 'Add New Project' ?>
                </h4>
                <form method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="<?= $edit_project ? 'edit' : 'add' ?>">
                    <?php if ($edit_project): ?>
                        <input type="hidden" name="id" value="<?= $edit_project['id'] ?>">
                        <input type="hidden" name="existing_image" value="<?= $edit_project['image'] ?>">
                    <?php endif; ?>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Project Title *</label>
                            <input type="text" class="form-control" name="title" required value="<?= sanitize($edit_project['title'] ?? '') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Category *</label>
                            <select class="form-select" name="category" required>
                                <option value="">Select category</option>
                                <option value="Websites" <?= ($edit_project['category'] ?? '') === 'Websites' ? 'selected' : '' ?>>Websites</option>
                                <option value="Web Systems" <?= ($edit_project['category'] ?? '') === 'Web Systems' ? 'selected' : '' ?>>Web Systems</option>
                                <option value="Mobile Apps" <?= ($edit_project['category'] ?? '') === 'Mobile Apps' ? 'selected' : '' ?>>Mobile Apps</option>
                                <option value="E-Commerce" <?= ($edit_project['category'] ?? '') === 'E-Commerce' ? 'selected' : '' ?>>E-Commerce</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description *</label>
                            <textarea class="form-control" name="description" rows="3" required><?= sanitize($edit_project['description'] ?? '') ?></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Technologies (comma separated)</label>
                            <input type="text" class="form-control" name="technologies" value="<?= sanitize($edit_project['technologies'] ?? '') ?>" placeholder="PHP, MySQL, Bootstrap">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Live URL</label>
                            <input type="url" class="form-control" name="live_url" value="<?= sanitize($edit_project['live_url'] ?? '#') ?>">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">GitHub URL</label>
                            <input type="url" class="form-control" name="github_url" value="<?= sanitize($edit_project['github_url'] ?? '#') ?>">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Project Image</label>
                            <input type="file" class="form-control" name="image" accept="image/*">
                            <?php if (!empty($edit_project['image'])): ?>
                                <small style="color: #7a7a9e;">Current: <?= basename($edit_project['image']) ?></small>
                            <?php endif; ?>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Sort Order</label>
                            <input type="number" class="form-control" name="sort_order" value="<?= $edit_project['sort_order'] ?? 0 ?>">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check-lg me-1"></i><?= $edit_project ? 'Update' : 'Add' ?> Project
                            </button>
                        </div>
                    </div>
                    
                    <?php if ($edit_project): ?>
                        <div class="mt-3">
                            <a href="projects.php" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-x-lg me-1"></i>Cancel Edit
                            </a>
                        </div>
                    <?php endif; ?>
                </form>
            </div>

            <!-- Projects Table -->
            <div class="admin-table">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Image</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Technologies</th>
                                <th>Order</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($projects)): ?>
                                <?php foreach ($projects as $i => $proj): ?>
                                    <tr>
                                        <td><?= $i + 1 ?></td>
                                        <td>
                                            <?php if ($proj['image'] && file_exists($proj['image'])): ?>
                                                <img src="../<?= sanitize($proj['image']) ?>" alt="" style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px;">
                                            <?php else: ?>
                                                <div style="width: 50px; height: 50px; background: var(--gradient-1); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff;"><i class="bi bi-image"></i></div>
                                            <?php endif; ?>
                                        </td>
                                        <td style="color: #fff; font-weight: 600;"><?= sanitize($proj['title']) ?></td>
                                        <td><span style="color: #a29bfe; font-size: 0.85rem;"><?= sanitize($proj['category']) ?></span></td>
                                        <td><small style="color: #7a7a9e;"><?= sanitize($proj['technologies']) ?></small></td>
                                        <td><?= $proj['sort_order'] ?></td>
                                        <td>
                                            <div class="d-flex gap-1">
                                                <a href="?edit=<?= $proj['id'] ?>" class="btn btn-sm btn-outline-primary" title="Edit"><i class="bi bi-pencil"></i></a>
                                                <a href="?delete=<?= $proj['id'] ?>" class="btn btn-sm btn-outline-danger" title="Delete" onclick="return confirm('Delete this project?')"><i class="bi bi-trash"></i></a>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="7" style="text-align: center; color: #7a7a9e; padding: 40px;">No projects yet.</td>
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
