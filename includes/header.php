<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <!-- SEO Meta Tags -->
    <title><?= isset($page_title) ? sanitize($page_title) . ' | ' . SITE_NAME : SITE_NAME . ' - ' . SITE_DESCRIPTION ?></title>
    <meta name="description" content="<?= isset($meta_description) ? sanitize($meta_description) : 'Professional web and mobile app developer. Custom websites, PHP systems, Flutter apps, and digital solutions.' ?>">
    <meta name="keywords" content="web developer, mobile app developer, PHP developer, Flutter, portfolio, web design, e-commerce, Saudi Arabia, Sudan">
    <meta name="author" content="<?= OWNER_NAME ?>">
    <meta name="robots" content="index, follow">
    
    <!-- Open Graph -->
    <meta property="og:title" content="<?= SITE_NAME ?> - <?= SITE_DESCRIPTION ?>">
    <meta property="og:description" content="Professional web and mobile app developer specializing in modern digital solutions.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="<?= SITE_URL ?>">
    <meta property="og:image" content="<?= SITE_URL ?>/<?= PROFILE_IMAGE ?>">
    <meta property="og:site_name" content="<?= SITE_NAME ?>">
    
    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="<?= SITE_NAME ?> - <?= SITE_DESCRIPTION ?>">
    <meta name="twitter:description" content="Professional web and mobile app developer specializing in modern digital solutions.">
    <meta name="twitter:image" content="<?= SITE_URL ?>/<?= PROFILE_IMAGE ?>">
    
    <!-- Favicon -->
    <link rel="icon" type="image/svg+xml" href="assets/images/favicon.svg">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Fira+Code:wght@400;500&display=swap" rel="stylesheet">
    
    <!-- Animate.css -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="assets/css/style.css" rel="stylesheet">
    
    <!-- Theme: load saved immediately to prevent flash -->
    <script>
        (function(){
            var t = localStorage.getItem('theme') || 'dark';
            document.documentElement.setAttribute('data-bs-theme', t);
        })();
    </script>
</head>
<body>
