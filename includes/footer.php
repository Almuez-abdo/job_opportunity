<!-- Footer -->
<footer class="site-footer">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <div class="footer-brand">
                    <span class="brand-text">Elmuez<span class="brand-accent">Abd Alla</span></span>
                </div>
                <p class="footer-desc"><?= OWNER_TAGLINE ?></p>
                <div class="footer-social">
                    <a href="<?= SOCIAL_WHATSAPP ?? '#' ?>" target="_blank" rel="noopener" aria-label="WhatsApp"><i class="bi bi-whatsapp"></i></a>
                    <a href="<?= SOCIAL_GITHUB ?>" target="_blank" rel="noopener" aria-label="GitHub"><i class="bi bi-github"></i></a>
                    <a href="<?= SOCIAL_LINKEDIN ?>" target="_blank" rel="noopener" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
                    <a href="<?= SOCIAL_FACEBOOK ?>" target="_blank" rel="noopener" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="<?= SOCIAL_INSTAGRAM ?>" target="_blank" rel="noopener" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                    <a href="<?= SOCIAL_EMAIL ?>" aria-label="Email"><i class="bi bi-envelope-fill"></i></a>
                </div>
            </div>
            
            <div class="col-lg-2 col-md-6">
                <h5 class="footer-title">Quick Links</h5>
                <ul class="footer-links">
                    <li><a href="index.php#hero">Home</a></li>
                    <li><a href="index.php#about">About</a></li>
                    <li><a href="index.php#services">Services</a></li>
                    <li><a href="index.php#portfolio">Portfolio</a></li>
                    <li><a href="index.php#contact">Contact</a></li>
                </ul>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <h5 class="footer-title">Services</h5>
                <ul class="footer-links">
                    <li><a href="index.php#services">Web Development</a></li>
                    <li><a href="index.php#services">Mobile Apps</a></li>
                    <li><a href="index.php#services">PHP Systems</a></li>
                    <li><a href="index.php#services">E-Commerce</a></li>
                    <li><a href="index.php#services">UI/UX Design</a></li>
                </ul>
            </div>
            
            <div class="col-lg-3 col-md-6">
                <h5 class="footer-title">Contact Info</h5>
                <ul class="footer-contact">
                    <li><i class="bi bi-geo-alt-fill"></i> <?= OWNER_LOCATION ?></li>
                    <li><i class="bi bi-envelope-fill"></i> <?= OWNER_EMAIL ?></li>
                    <li><i class="bi bi-phone-fill"></i> <?= OWNER_PHONE ?></li>
                </ul>
            </div>
        </div>
        
        <hr class="footer-divider">
        
        <div class="footer-bottom">
            <p>&copy; <?= date('Y') ?> <?= SITE_NAME ?>. All Rights Reserved.</p>
            <p class="footer-creator">Create By <span class="creator-name">Elmuez Abd Alla</span></p>
        </div>
    </div>
</footer>

<!-- WhatsApp Floating Button -->
<a href="https://wa.me/<?= OWNER_WHATSAPP ?>?text=<?= urlencode(WHATSAPP_MESSAGE) ?>" 
   class="whatsapp-float" target="_blank" rel="noopener" aria-label="Chat on WhatsApp">
    <i class="bi bi-whatsapp"></i>
</a>

<!-- Back to Top Button -->
<button class="back-to-top" id="backToTop" aria-label="Back to top">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Animate On Scroll -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

<!-- Custom JS -->
<script src="assets/js/main.js"></script>

</body>
</html>
