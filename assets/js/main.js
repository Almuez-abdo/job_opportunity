/**
 * Ezo Service - Main JavaScript
 */

document.addEventListener('DOMContentLoaded', function() {

    // ===== Theme Toggle (FIRST - no dependencies) =====
    var themeToggle = document.getElementById('themeToggle');
    var themeIcon = document.getElementById('themeIcon');
    var html = document.documentElement;

    var savedTheme = localStorage.getItem('theme') || 'dark';
    html.setAttribute('data-bs-theme', savedTheme);
    if (themeIcon) {
        themeIcon.className = savedTheme === 'dark' ? 'bi bi-moon-stars-fill' : 'bi bi-sun-fill';
    }

    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            var current = html.getAttribute('data-bs-theme');
            var next = (current === 'dark') ? 'light' : 'dark';
            html.setAttribute('data-bs-theme', next);
            localStorage.setItem('theme', next);
            themeIcon.className = (next === 'dark') ? 'bi bi-moon-stars-fill' : 'bi bi-sun-fill';
        });
    }

    // ===== Initialize AOS (safe) =====
    try {
        if (typeof AOS !== 'undefined') {
            AOS.init({ duration: 800, easing: 'ease-in-out', once: true, offset: 50 });
        }
    } catch(e) { console.warn('AOS init failed:', e); }

    // ===== Navbar Scroll Effect =====
    var navbar = document.getElementById('mainNav');
    if (navbar) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // ===== Active Nav Link on Scroll =====
    var sections = document.querySelectorAll('section[id]');
    var navLinks = document.querySelectorAll('.navbar-nav .nav-link');

    window.addEventListener('scroll', function() {
        var current = '';
        sections.forEach(function(section) {
            var sectionTop = section.offsetTop - 100;
            if (window.scrollY >= sectionTop) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(function(link) {
            link.classList.remove('active');
            if (link.getAttribute('href') && link.getAttribute('href').includes('#' + current)) {
                link.classList.add('active');
            }
        });
    });

    // ===== Close Mobile Nav on Link Click =====
    var navbarCollapse = document.getElementById('navbarNav');
    if (navbarCollapse) {
        navLinks.forEach(function(link) {
            link.addEventListener('click', function() {
                if (navbarCollapse.classList.contains('show')) {
                    try {
                        var bsCollapse = bootstrap.Collapse.getInstance(navbarCollapse);
                        if (bsCollapse) bsCollapse.hide();
                    } catch(e) {}
                }
            });
        });
    }

    // ===== Back to Top Button =====
    var backToTop = document.getElementById('backToTop');
    if (backToTop) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 500) {
                backToTop.classList.add('visible');
            } else {
                backToTop.classList.remove('visible');
            }
        });
        backToTop.addEventListener('click', function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    // ===== Typing Animation =====
    var typingElement = document.getElementById('typingText');
    if (typingElement) {
        var texts = [
            'Web Developer',
            'Mobile App Developer',
            'PHP Developer',
            'Flutter Developer',
            'UI/UX Enthusiast',
            'IT Specialist'
        ];
        var textIndex = 0;
        var charIndex = 0;
        var isDeleting = false;
        var typingDelay = 100;

        function typeText() {
            var currentText = texts[textIndex];

            if (isDeleting) {
                typingElement.textContent = currentText.substring(0, charIndex - 1);
                charIndex--;
                typingDelay = 50;
            } else {
                typingElement.textContent = currentText.substring(0, charIndex + 1);
                charIndex++;
                typingDelay = 100;
            }

            if (!isDeleting && charIndex === currentText.length) {
                typingDelay = 2000;
                isDeleting = true;
            } else if (isDeleting && charIndex === 0) {
                isDeleting = false;
                textIndex = (textIndex + 1) % texts.length;
                typingDelay = 500;
            }

            setTimeout(typeText, typingDelay);
        }

        typeText();
    }

    // ===== Counter Animation =====
    var counters = document.querySelectorAll('.stat-number');
    var countersAnimated = false;

    function animateCounters() {
        counters.forEach(function(counter) {
            var target = parseInt(counter.getAttribute('data-target'));
            if (isNaN(target)) return;
            var duration = 2000;
            var step = target / (duration / 16);
            var current = 0;

            function updateCounter() {
                current += step;
                if (current < target) {
                    counter.textContent = Math.floor(current) + '+';
                    requestAnimationFrame(updateCounter);
                } else {
                    counter.textContent = target + '+';
                }
            }

            updateCounter();
        });
    }

    var statsSection = document.querySelector('.stats-grid');
    if (statsSection) {
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting && !countersAnimated) {
                    countersAnimated = true;
                    animateCounters();
                }
            });
        }, { threshold: 0.5 });
        observer.observe(statsSection);
    }

    // ===== Skill Bar Animation =====
    var skillBars = document.querySelectorAll('.skill-bar-fill');
    var skillsSection = document.getElementById('skills');

    if (skillsSection) {
        var skillsObserver = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    skillBars.forEach(function(bar) {
                        bar.classList.add('animated');
                    });
                }
            });
        }, { threshold: 0.3 });
        skillsObserver.observe(skillsSection);
    }

    // ===== Portfolio Filter =====
    var filterBtns = document.querySelectorAll('.filter-btn');
    var portfolioItems = document.querySelectorAll('.portfolio-item');

    filterBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            filterBtns.forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');

            var filter = btn.getAttribute('data-filter');

            portfolioItems.forEach(function(item) {
                if (filter === 'all' || item.getAttribute('data-category') === filter) {
                    item.style.display = '';
                    setTimeout(function() {
                        item.style.opacity = '1';
                        item.style.transform = 'scale(1)';
                    }, 50);
                } else {
                    item.style.opacity = '0';
                    item.style.transform = 'scale(0.8)';
                    setTimeout(function() {
                        item.style.display = 'none';
                    }, 300);
                }
            });
        });
    });

    // ===== Contact Form AJAX =====
    var contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();

            var formData = new FormData(contactForm);
            var submitBtn = contactForm.querySelector('button[type="submit"]');
            var originalText = submitBtn.innerHTML;

            submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Sending...';
            submitBtn.disabled = true;

            fetch('ajax/contact.php', {
                method: 'POST',
                body: formData
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var alertDiv = document.getElementById('formAlert');
                if (data.success) {
                    alertDiv.innerHTML = '<div class="alert alert-success alert-dismissible fade show">' +
                        '<i class="bi bi-check-circle-fill me-2"></i>' + data.message +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
                    contactForm.reset();
                } else {
                    alertDiv.innerHTML = '<div class="alert alert-danger alert-dismissible fade show">' +
                        '<i class="bi bi-exclamation-triangle-fill me-2"></i>' + data.message +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
                }
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            })
            .catch(function() {
                var alertDiv = document.getElementById('formAlert');
                alertDiv.innerHTML = '<div class="alert alert-danger alert-dismissible fade show">' +
                    '<i class="bi bi-exclamation-triangle-fill me-2"></i>An error occurred. Please try again.' +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });
    }

    // ===== Smooth Scroll for Anchor Links =====
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            var href = this.getAttribute('href');
            if (href === '#') return;

            e.preventDefault();
            var target = document.querySelector(href);
            if (target) {
                var navHeight = document.getElementById('mainNav').offsetHeight;
                var targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navHeight;
                window.scrollTo({ top: targetPosition, behavior: 'smooth' });
            }
        });
    });
});
