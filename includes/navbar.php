<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg fixed-top" id="mainNav">
    <div class="container">
        <a class="navbar-brand" href="index.php">
            <span class="brand-text">Elmuez<span class="brand-accent">Abd Alla</span></span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'home' ? 'active' : '' ?>" href="index.php#hero">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'about' ? 'active' : '' ?>" href="index.php#about">About</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'services' ? 'active' : '' ?>" href="index.php#services">Services</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'skills' ? 'active' : '' ?>" href="index.php#skills">Skills</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'portfolio' ? 'active' : '' ?>" href="index.php#portfolio">Portfolio</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'experience' ? 'active' : '' ?>" href="index.php#experience">Experience</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?= get_current_page() === 'contact' ? 'active' : '' ?>" href="index.php#contact">Contact</a>
                </li>
                <li class="nav-item ms-lg-2">
                    <button class="theme-toggle" id="themeToggle" aria-label="Toggle dark/light mode" onclick="var h=document.documentElement;var c=h.getAttribute('data-bs-theme');var n=c==='dark'?'light':'dark';h.setAttribute('data-bs-theme',n);localStorage.setItem('theme',n);document.getElementById('themeIcon').className=n==='dark'?'bi bi-moon-stars-fill':'bi bi-sun-fill';">
                        <i class="bi bi-moon-stars-fill" id="themeIcon"></i>
                    </button>
                </li>
                <li class="nav-item ms-lg-2">
                    <a href="index.php#contact" class="btn btn-primary btn-hire">Hire Me</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
