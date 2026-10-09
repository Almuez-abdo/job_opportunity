<?php
/**
 * Ezo Service - Home Page
 */

$page_title = 'Home';
$meta_description = 'Professional web and mobile app developer specializing in PHP, Flutter, and modern digital solutions.';

require_once 'includes/functions.php';

// Fetch services from database
try {
    $stmt = $pdo->query("SELECT * FROM services ORDER BY sort_order ASC LIMIT 9");
    $services = $stmt->fetchAll();
} catch (PDOException $e) {
    $services = [];
}

// Fetch projects from database
try {
    $stmt = $pdo->query("SELECT * FROM projects ORDER BY sort_order ASC LIMIT 6");
    $projects = $stmt->fetchAll();
} catch (PDOException $e) {
    $projects = [];
}

require_once 'includes/header.php';
require_once 'includes/navbar.php';
?>

<!-- Hero Section -->
<section id="hero">
    <div class="hero-bg-shapes">
        <div class="hero-shape hero-shape-1"></div>
        <div class="hero-shape hero-shape-2"></div>
        <div class="hero-shape hero-shape-3"></div>
    </div>
    
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7 hero-content">
                <p class="hero-greeting animate__animated animate__fadeInDown">Hello, I'm</p>
                <h1 class="hero-name animate__animated animate__fadeInUp">
                    <span class="accent"><?= OWNER_FULL_NAME ?></span>
                </h1>
                <div class="hero-title-wrapper animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
                    I'm a <span class="hero-title" id="typingText"></span><span class="typing-cursor"></span>
                </div>
                <p class="hero-description animate__animated animate__fadeInUp" style="animation-delay: 0.4s">
                    I design and develop modern websites, web systems, and mobile applications that help businesses transform their ideas into powerful digital solutions.
                </p>
                <div class="hero-buttons animate__animated animate__fadeInUp" style="animation-delay: 0.6s">
                    <a href="#portfolio" class="btn-hero btn-hero-primary">
                        <i class="bi bi-eye-fill"></i> View My Work
                    </a>
                    <a href="#contact" class="btn-hero btn-hero-outline">
                        <i class="bi bi-envelope-fill"></i> Contact Me
                    </a>
                    <a href="<?= CV_FILE ?>" class="btn-hero btn-hero-outline" download>
                        <i class="bi bi-download"></i> Download CV
                    </a>
                </div>
                <div class="hero-social animate__animated animate__fadeInUp" style="animation-delay: 0.8s">
                    <a href="https://wa.me/<?= OWNER_WHATSAPP ?>" target="_blank" rel="noopener" aria-label="WhatsApp"><i class="bi bi-whatsapp"></i></a>
                    <a href="<?= SOCIAL_GITHUB ?>" target="_blank" rel="noopener" aria-label="GitHub"><i class="bi bi-github"></i></a>
                    <a href="<?= SOCIAL_LINKEDIN ?>" target="_blank" rel="noopener" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                    <a href="<?= SOCIAL_FACEBOOK ?>" target="_blank" rel="noopener" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="<?= SOCIAL_INSTAGRAM ?>" target="_blank" rel="noopener" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                    <a href="<?= SOCIAL_EMAIL ?>" aria-label="Email"><i class="bi bi-envelope-fill"></i></a>
                </div>
            </div>
            
            <div class="col-lg-5 hero-image-wrapper">
                <div class="animate__animated animate__fadeInRight" style="animation-delay: 0.5s">
                    <div class="hero-image-container">
                        <img src="<?= PROFILE_IMAGE ?>" alt="<?= OWNER_NAME ?> - Profile Picture" loading="lazy">
                    </div>
                    <div class="hero-image-ring"></div>
                    <div class="hero-image-dots">
                        <span class="dot"></span>
                        <span class="dot"></span>
                        <span class="dot"></span>
                        <span class="dot"></span>
                        <span class="dot"></span>
                        <span class="dot"></span>
                    </div>
                    
                    <div class="hero-float-card hero-float-card-1">
                        <i class="bi bi-code-slash"></i>
                        <span>50+ Projects Done</span>
                    </div>
                    <div class="hero-float-card hero-float-card-2">
                        <i class="bi bi-star-fill"></i>
                        <span>5+ Years Experience</span>
                    </div>
                    <div class="hero-float-card hero-float-card-3">
                        <i class="bi bi-people-fill"></i>
                        <span>30+ Happy Clients</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- About Section -->
<section id="about" class="section">
    <div class="container">
        <div class="row align-items-center g-5">
            <div class="col-lg-6" data-aos="fade-right">
                <div class="section-header text-start">
                    <h2>About <span class="accent">Me</span></h2>
                    <div class="section-divider" style="margin-left:0"></div>
                </div>
                <div class="about-content">
                    <p>
                        I am an Information Technology professional and software developer specializing in web development, PHP systems, and mobile application development. I help individuals and businesses build reliable, modern, and user-friendly digital solutions.
                    </p>
                    <p>
                        With years of experience in the field, I bring a combination of technical expertise and creative problem-solving to every project. Whether it's a complex web system, a responsive website, or a mobile application, I deliver quality results that exceed expectations.
                    </p>
                </div>
                
                <div class="about-info-grid">
                    <div class="about-info-item">
                        <i class="bi bi-person-fill"></i>
                        <div>
                            <span class="info-label">Name</span>
                            <span class="info-value"><?= OWNER_FULL_NAME ?></span>
                        </div>
                    </div>
                    <div class="about-info-item">
                        <i class="bi bi-briefcase-fill"></i>
                        <div>
                            <span class="info-label">Profession</span>
                            <span class="info-value">Web & Mobile Developer</span>
                        </div>
                    </div>
                    <div class="about-info-item">
                        <i class="bi bi-geo-alt-fill"></i>
                        <div>
                            <span class="info-label">Location</span>
                            <span class="info-value"><?= OWNER_LOCATION ?></span>
                        </div>
                    </div>
                    <div class="about-info-item">
                        <i class="bi bi-envelope-fill"></i>
                        <div>
                            <span class="info-label">Email</span>
                            <span class="info-value"><?= OWNER_EMAIL ?></span>
                        </div>
                    </div>
                    <div class="about-info-item">
                        <i class="bi bi-phone-fill"></i>
                        <div>
                            <span class="info-label">Phone</span>
                            <span class="info-value"><?= OWNER_PHONE ?></span>
                        </div>
                    </div>
                    <div class="about-info-item">
                        <i class="bi bi-calendar-check-fill"></i>
                        <div>
                            <span class="info-label">Freelance</span>
                            <span class="info-value">Available</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-6" data-aos="fade-left">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-folder-check"></i></div>
                        <div class="stat-number" data-target="50">0</div>
                        <div class="stat-label">Projects Completed</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-emoji-smile"></i></div>
                        <div class="stat-number" data-target="30">0</div>
                        <div class="stat-label">Happy Clients</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-clock-history"></i></div>
                        <div class="stat-number" data-target="5">0</div>
                        <div class="stat-label">Years Experience</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon"><i class="bi bi-laptop"></i></div>
                        <div class="stat-number" data-target="20">0</div>
                        <div class="stat-label">Technologies Used</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section id="services" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>My <span class="accent">Services</span></h2>
            <p>I provide professional digital solutions tailored to your business needs.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row g-4">
            <?php if (!empty($services)): ?>
                <?php foreach ($services as $index => $service): ?>
                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="<?= ($index % 3) * 100 ?>">
                        <div class="service-card">
                            <div class="service-icon">
                                <i class="bi <?= sanitize($service['icon']) ?>"></i>
                            </div>
                            <h4><?= sanitize($service['title']) ?></h4>
                            <p><?= sanitize($service['description']) ?></p>
                            <a href="#contact" class="btn-service">
                                Learn More <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>
</section>

<!-- Skills Section -->
<section id="skills" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>My <span class="accent">Skills</span></h2>
            <p>Technologies and tools I work with to bring ideas to life.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="0">
                <div class="skills-category">
                    <h4><i class="bi bi-palette"></i> Frontend</h4>
                    <div class="skill-item">
                        <div class="skill-icon">H5</div>
                        <div class="skill-info">
                            <div class="skill-name">HTML5</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 95%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">C3</div>
                        <div class="skill-info">
                            <div class="skill-name">CSS3</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 90%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">JS</div>
                        <div class="skill-info">
                            <div class="skill-name">JavaScript</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 85%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">B5</div>
                        <div class="skill-info">
                            <div class="skill-name">Bootstrap</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 92%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">RD</div>
                        <div class="skill-info">
                            <div class="skill-name">Responsive Design</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 95%"></div></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                <div class="skills-category">
                    <h4><i class="bi bi-server"></i> Backend</h4>
                    <div class="skill-item">
                        <div class="skill-icon">PH</div>
                        <div class="skill-info">
                            <div class="skill-name">PHP</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 90%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">MY</div>
                        <div class="skill-info">
                            <div class="skill-name">MySQL</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 88%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">API</div>
                        <div class="skill-info">
                            <div class="skill-name">REST API</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 82%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">AJ</div>
                        <div class="skill-info">
                            <div class="skill-name">AJAX</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 85%"></div></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                <div class="skills-category">
                    <h4><i class="bi bi-phone"></i> Mobile</h4>
                    <div class="skill-item">
                        <div class="skill-icon">FL</div>
                        <div class="skill-info">
                            <div class="skill-name">Flutter</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 88%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">DA</div>
                        <div class="skill-info">
                            <div class="skill-name">Dart</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 85%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">AN</div>
                        <div class="skill-info">
                            <div class="skill-name">Android Dev</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 80%"></div></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                <div class="skills-category">
                    <h4><i class="bi bi-tools"></i> Tools</h4>
                    <div class="skill-item">
                        <div class="skill-icon">VS</div>
                        <div class="skill-info">
                            <div class="skill-name">VS Code</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 95%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">AS</div>
                        <div class="skill-info">
                            <div class="skill-name">Android Studio</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 85%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">GT</div>
                        <div class="skill-info">
                            <div class="skill-name">Git / GitHub</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 88%"></div></div>
                        </div>
                    </div>
                    <div class="skill-item">
                        <div class="skill-icon">XAM</div>
                        <div class="skill-info">
                            <div class="skill-name">XAMPP</div>
                            <div class="skill-bar"><div class="skill-bar-fill" style="--skill-level: 90%"></div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Optional Skills -->
        <div class="row mt-4">
            <div class="col-12" data-aos="fade-up">
                <div class="skills-category">
                    <h4><i class="bi bi-plus-circle"></i> Additional Skills</h4>
                    <div class="d-flex flex-wrap gap-3">
                        <span class="skill-item" style="margin-bottom:0; display:inline-flex;">
                            <div class="skill-icon">LV</div>
                            <div class="skill-info"><div class="skill-name">Laravel</div></div>
                        </span>
                        <span class="skill-item" style="margin-bottom:0; display:inline-flex;">
                            <div class="skill-icon">JQ</div>
                            <div class="skill-info"><div class="skill-name">jQuery</div></div>
                        </span>
                        <span class="skill-item" style="margin-bottom:0; display:inline-flex;">
                            <div class="skill-icon">AI</div>
                            <div class="skill-info"><div class="skill-name">API Integration</div></div>
                        </span>
                        <span class="skill-item" style="margin-bottom:0; display:inline-flex;">
                            <div class="skill-icon">DB</div>
                            <div class="skill-info"><div class="skill-name">Database Design</div></div>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Portfolio Section -->
<section id="portfolio" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>My <span class="accent">Portfolio</span></h2>
            <p>Here are some of my recent projects that showcase my expertise.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="portfolio-filters" data-aos="fade-up">
            <button class="filter-btn active" data-filter="all">All</button>
            <button class="filter-btn" data-filter="Websites">Websites</button>
            <button class="filter-btn" data-filter="Web Systems">Web Systems</button>
            <button class="filter-btn" data-filter="Mobile Apps">Mobile Apps</button>
            <button class="filter-btn" data-filter="E-Commerce">E-Commerce</button>
        </div>
        
        <div class="row g-4">
            <?php if (!empty($projects)): ?>
                <?php foreach ($projects as $project): ?>
                    <div class="col-lg-4 col-md-6 portfolio-item" data-category="<?= sanitize($project['category']) ?>" data-aos="fade-up">
                        <div class="portfolio-card">
                            <div class="portfolio-image">
                                <?php if ($project['image'] && file_exists($project['image'])): ?>
                                    <img src="<?= sanitize($project['image']) ?>" alt="<?= sanitize($project['title']) ?>" loading="lazy">
                                <?php else: ?>
                                    <div class="placeholder-img"><i class="bi bi-code-square"></i></div>
                                <?php endif; ?>
                                <div class="portfolio-overlay">
                                    <?php if ($project['live_url'] && $project['live_url'] !== '#'): ?>
                                        <a href="<?= sanitize($project['live_url']) ?>" target="_blank" rel="noopener" title="Live Demo"><i class="bi bi-eye-fill"></i></a>
                                    <?php endif; ?>
                                    <?php if ($project['github_url'] && $project['github_url'] !== '#'): ?>
                                        <a href="<?= sanitize($project['github_url']) ?>" target="_blank" rel="noopener" title="GitHub"><i class="bi bi-github"></i></a>
                                    <?php endif; ?>
                                    <a href="#" data-bs-toggle="modal" data-bs-target="#projectModal<?= $project['id'] ?>" title="Details"><i class="bi bi-info-circle-fill"></i></a>
                                </div>
                            </div>
                            <div class="portfolio-info">
                                <span class="portfolio-category"><?= sanitize($project['category']) ?></span>
                                <h4><?= sanitize($project['title']) ?></h4>
                                <p><?= sanitize(substr($project['description'], 0, 100)) ?>...</p>
                                <div class="portfolio-tech">
                                    <?php
                                    $techs = explode(',', $project['technologies']);
                                    foreach ($techs as $tech):
                                    ?>
                                        <span><?= sanitize(trim($tech)) ?></span>
                                    <?php endforeach; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Project Modal -->
                    <div class="modal fade" id="projectModal<?= $project['id'] ?>" tabindex="-1">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content" style="background: var(--bg-card); border: 1px solid var(--border-color);">
                                <div class="modal-header" style="border-color: var(--border-color);">
                                    <h5 class="modal-title"><?= sanitize($project['title']) ?></h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <?php if ($project['image'] && file_exists($project['image'])): ?>
                                        <img src="<?= sanitize($project['image']) ?>" class="w-100 mb-3" alt="<?= sanitize($project['title']) ?>" style="border-radius: var(--radius);">
                                    <?php endif; ?>
                                    <p style="color: var(--text-secondary);"><?= sanitize($project['description']) ?></p>
                                    <div class="portfolio-tech mt-3">
                                        <?php foreach ($techs as $tech): ?>
                                            <span><?= sanitize(trim($tech)) ?></span>
                                        <?php endforeach; ?>
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-color: var(--border-color);">
                                    <?php if ($project['live_url'] && $project['live_url'] !== '#'): ?>
                                        <a href="<?= sanitize($project['live_url']) ?>" target="_blank" class="btn btn-primary btn-sm"><i class="bi bi-eye-fill me-1"></i> Live Demo</a>
                                    <?php endif; ?>
                                    <?php if ($project['github_url'] && $project['github_url'] !== '#'): ?>
                                        <a href="<?= sanitize($project['github_url']) ?>" target="_blank" class="btn btn-outline-primary btn-sm"><i class="bi bi-github me-1"></i> GitHub</a>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>
</section>

<!-- Experience Section -->
<section id="experience" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>My <span class="accent">Experience</span></h2>
            <p>My professional journey and the roles I've undertaken.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="timeline">
                    <div class="timeline-item" data-aos="fade-up">
                        <div class="timeline-dot"></div>
                        <span class="timeline-date">2020 - Present</span>
                        <h4>Freelance Web Developer</h4>
                        <p>Developing websites, PHP systems, and web applications for different clients. Building responsive, modern, and user-friendly digital solutions that help businesses grow and succeed online.</p>
                    </div>
                    
                    <div class="timeline-item" data-aos="fade-up" data-aos-delay="100">
                        <div class="timeline-dot"></div>
                        <span class="timeline-date">2021 - Present</span>
                        <h4>Mobile App Developer</h4>
                        <p>Building mobile applications using Flutter and Dart. Creating cross-platform apps with native performance, beautiful UI, and robust functionality for Android and iOS.</p>
                    </div>
                    
                    <div class="timeline-item" data-aos="fade-up" data-aos-delay="200">
                        <div class="timeline-dot"></div>
                        <span class="timeline-date">2019 - Present</span>
                        <h4>IT & Technical Services</h4>
                        <p>Providing technical support and digital solutions. Database development, system administration, network support, and comprehensive IT consulting services.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Work Process Section -->
<section id="process" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>Work <span class="accent">Process</span></h2>
            <p>My structured approach to delivering exceptional results.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="process-steps">
            <div class="process-step" data-aos="fade-up" data-aos-delay="0">
                <div class="process-step-number">1</div>
                <i class="bi bi-chat-dots" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Discuss the Idea</h4>
                <p>Understanding your vision, goals, and requirements through detailed discussion.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="100">
                <div class="process-step-number">2</div>
                <i class="bi bi-clipboard-data" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Planning & Analysis</h4>
                <p>Creating a detailed plan, timeline, and technical roadmap for the project.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="200">
                <div class="process-step-number">3</div>
                <i class="bi bi-palette" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>UI/UX Design</h4>
                <p>Designing modern, intuitive interfaces with focus on user experience.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="300">
                <div class="process-step-number">4</div>
                <i class="bi bi-code-slash" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Development</h4>
                <p>Building the project with clean, efficient, and maintainable code.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="400">
                <div class="process-step-number">5</div>
                <i class="bi bi-bug" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Testing</h4>
                <p>Thorough testing to ensure quality, performance, and compatibility.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="500">
                <div class="process-step-number">6</div>
                <i class="bi bi-rocket-takeoff" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Delivery</h4>
                <p>Final delivery with all files, documentation, and deployment support.</p>
            </div>
            
            <div class="process-step" data-aos="fade-up" data-aos-delay="600">
                <div class="process-step-number">7</div>
                <i class="bi bi-headset" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 10px; display: block;"></i>
                <h4>Technical Support</h4>
                <p>Ongoing maintenance, updates, and technical assistance after delivery.</p>
            </div>
        </div>
    </div>
</section>

<!-- Why Choose Me Section -->
<section id="why" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>Why <span class="accent">Choose Me</span></h2>
            <p>What makes me the right choice for your project.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row g-4">
            <?php
            $benefits = [
                ['icon' => 'bi-palette', 'title' => 'Clean & Modern Design', 'desc' => 'Beautiful, contemporary designs that make a lasting impression.'],
                ['icon' => 'bi-phone', 'title' => 'Responsive Development', 'desc' => 'Websites that look and work perfectly on all devices.'],
                ['icon' => 'bi-shield-check', 'title' => 'Reliable Code', 'desc' => 'Clean, well-structured, and maintainable code.'],
                ['icon' => 'bi-chat-dots', 'title' => 'Fast Communication', 'desc' => 'Quick responses and clear updates throughout the project.'],
                ['icon' => 'bi-gear', 'title' => 'Custom Solutions', 'desc' => 'Tailored solutions designed specifically for your needs.'],
                ['icon' => 'bi-headset', 'title' => 'Ongoing Support', 'desc' => 'Continued assistance and maintenance after project delivery.'],
                ['icon' => 'bi-lock', 'title' => 'Secure Development', 'desc' => 'Security-first approach to protect your data and users.'],
                ['icon' => 'bi-search', 'title' => 'Attention to Detail', 'desc' => 'Meticulous focus on every aspect of the project.'],
            ];
            foreach ($benefits as $index => $benefit):
            ?>
                <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="<?= ($index % 4) * 100 ?>">
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="bi <?= $benefit['icon'] ?>"></i>
                        </div>
                        <h5><?= $benefit['title'] ?></h5>
                        <p><?= $benefit['desc'] ?></p>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section id="testimonials" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>Client <span class="accent">Testimonials</span></h2>
            <p>What my clients say about working with me.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row g-4">
            <?php
            $testimonials = [
                [
                    'name' => 'Ahmed Hassan',
                    'role' => 'Business Owner',
                    'initials' => 'AH',
                    'rating' => 5,
                    'text' => 'Excellent work on our e-commerce platform. The website is fast, responsive, and looks amazing. Highly recommended for any web development project!'
                ],
                [
                    'name' => 'Fatima Al-Ali',
                    'role' => 'Startup Founder',
                    'initials' => 'FA',
                    'rating' => 5,
                    'text' => 'The mobile app developed using Flutter exceeded our expectations. Great communication, timely delivery, and professional quality code. Will work again!'
                ],
                [
                    'name' => 'Omar Khalil',
                    'role' => 'Restaurant Manager',
                    'initials' => 'OK',
                    'rating' => 5,
                    'text' => 'The cafeteria management system transformed our daily operations. Invoicing, product management, and reporting are now seamless. Thank you for the great work!'
                ],
            ];
            foreach ($testimonials as $index => $testimonial):
            ?>
                <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="<?= $index * 100 ?>">
                    <div class="testimonial-card">
                        <div class="testimonial-rating">
                            <?php for ($i = 0; $i < $testimonial['rating']; $i++): ?>
                                <i class="bi bi-star-fill"></i>
                            <?php endfor; ?>
                        </div>
                        <p class="testimonial-text">"<?= $testimonial['text'] ?>"</p>
                        <div class="testimonial-author">
                            <div class="testimonial-avatar"><?= $testimonial['initials'] ?></div>
                            <div class="testimonial-author-info">
                                <h5><?= $testimonial['name'] ?></h5>
                                <span><?= $testimonial['role'] ?></span>
                            </div>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section id="contact" class="section">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2>Get In <span class="accent">Touch</span></h2>
            <p>Have a project in mind? Let's discuss how I can help you.</p>
            <div class="section-divider"></div>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-5" data-aos="fade-right">
                <h4 style="font-weight: 700; margin-bottom: 20px;">Contact Information</h4>
                
                <div class="contact-info-card">
                    <i class="bi bi-phone-fill"></i>
                    <div>
                        <h6>Phone</h6>
                        <p><?= OWNER_PHONE ?></p>
                    </div>
                </div>
                
                <div class="contact-info-card">
                    <i class="bi bi-whatsapp"></i>
                    <div>
                        <h6>WhatsApp</h6>
                        <p>+<?= OWNER_WHATSAPP ?></p>
                    </div>
                </div>
                
                <div class="contact-info-card">
                    <i class="bi bi-envelope-fill"></i>
                    <div>
                        <h6>Email</h6>
                        <p><?= OWNER_EMAIL ?></p>
                    </div>
                </div>
                
                <div class="contact-info-card">
                    <i class="bi bi-geo-alt-fill"></i>
                    <div>
                        <h6>Location</h6>
                        <p><?= OWNER_LOCATION ?></p>
                    </div>
                </div>
                
                <div class="hero-social mt-4">
                    <a href="https://wa.me/<?= OWNER_WHATSAPP ?>" target="_blank" rel="noopener" aria-label="WhatsApp"><i class="bi bi-whatsapp"></i></a>
                    <a href="<?= SOCIAL_GITHUB ?>" target="_blank" rel="noopener" aria-label="GitHub"><i class="bi bi-github"></i></a>
                    <a href="<?= SOCIAL_LINKEDIN ?>" target="_blank" rel="noopener" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                    <a href="<?= SOCIAL_FACEBOOK ?>" target="_blank" rel="noopener" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="<?= SOCIAL_INSTAGRAM ?>" target="_blank" rel="noopener" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
            
            <div class="col-lg-7" data-aos="fade-left">
                <div class="contact-form">
                    <div id="formAlert"></div>
                    <form id="contactForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label">Full Name *</label>
                                <input type="text" class="form-control" id="name" name="name" required minlength="2" placeholder="Your full name">
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email Address *</label>
                                <input type="email" class="form-control" id="email" name="email" required placeholder="your@email.com">
                            </div>
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="+249 XX XXX XXXX">
                            </div>
                            <div class="col-md-6">
                                <label for="service" class="form-label">Service Required</label>
                                <select class="form-select" id="service" name="service">
                                    <option value="">Select a service</option>
                                    <option value="Mobile App Development">Mobile App Development</option>
                                    <option value="Website Development">Website Development</option>
                                    <option value="PHP System">PHP System</option>
                                    <option value="E-Commerce">E-Commerce</option>
                                    <option value="Landing Page">Landing Page</option>
                                    <option value="Website Maintenance">Website Maintenance</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="subject" class="form-label">Subject *</label>
                                <input type="text" class="form-control" id="subject" name="subject" required minlength="3" placeholder="What is this about?">
                            </div>
                            <div class="col-12">
                                <label for="message" class="form-label">Message *</label>
                                <textarea class="form-control" id="message" name="message" rows="5" required minlength="10" placeholder="Tell me about your project..."></textarea>
                            </div>
                            <!-- Honeypot anti-spam -->
                            <div style="position: absolute; left: -9999px;">
                                <input type="text" name="website" tabindex="-1" autocomplete="off">
                            </div>
                            <div class="col-12">
                                <button type="submit" class="btn-submit">
                                    <i class="bi bi-send-fill"></i> Send Message
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<?php require_once 'includes/footer.php'; ?>
