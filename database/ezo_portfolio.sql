-- =============================================
-- Elmuez Abd Alla Portfolio Database
-- MySQL Database Schema & Sample Data
-- =============================================

CREATE DATABASE IF NOT EXISTS `ezo_portfolio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ezo_portfolio`;

-- =============================================
-- Admins Table
-- =============================================
CREATE TABLE IF NOT EXISTS `admins` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Default admin: username=admin, password=admin123
-- Change the password after first login!
INSERT INTO `admins` (`username`, `password`) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- =============================================
-- Contact Messages Table
-- =============================================
CREATE TABLE IF NOT EXISTS `contact_messages` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `phone` VARCHAR(30) DEFAULT NULL,
    `subject` VARCHAR(200) NOT NULL,
    `service` VARCHAR(100) DEFAULT NULL,
    `message` TEXT NOT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `status` ENUM('new','read','replied') DEFAULT 'new',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Sample messages
INSERT INTO `contact_messages` (`name`, `email`, `phone`, `subject`, `service`, `message`, `ip_address`, `status`) VALUES
('Ahmed Ali', 'ahmed@example.com', '+249912345678', 'Website Development Inquiry', 'Website Development', 'I need a professional website for my business. Please contact me.', '127.0.0.1', 'new'),
('Sara Mohamed', 'sara@example.com', '+249987654321', 'Mobile App Project', 'Mobile App Development', 'I want to build a mobile app for my store. What is the cost?', '127.0.0.1', 'read'),
('Omar Hassan', 'omar@example.com', '+249955512345', 'E-Commerce System', 'E-Commerce', 'Need an online store with payment integration.', '127.0.0.1', 'new');

-- =============================================
-- Projects Table
-- =============================================
CREATE TABLE IF NOT EXISTS `projects` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(150) NOT NULL,
    `description` TEXT NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `technologies` VARCHAR(255) DEFAULT NULL,
    `image` VARCHAR(255) DEFAULT NULL,
    `live_url` VARCHAR(255) DEFAULT NULL,
    `github_url` VARCHAR(255) DEFAULT NULL,
    `sort_order` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Sample projects
INSERT INTO `projects` (`title`, `description`, `category`, `technologies`, `image`, `live_url`, `github_url`, `sort_order`) VALUES
('Ezo Store', 'Full-featured e-commerce platform with product management, shopping cart, orders, and payment-ready architecture.', 'E-Commerce', 'PHP, MySQL, JavaScript, Bootstrap', 'assets/images/project1.png', '#', '#', 1),
('Job Opportunity', 'Mobile and web platform connecting recruitment agencies with service seekers. Features real-time notifications and chat.', 'Mobile Apps', 'Flutter, Dart, PHP, REST API', 'assets/images/project2.png', '#', '#', 2),
('PharmaSudan', 'Platform connecting pharmaceutical companies with pharmacies for product distribution and ordering.', 'Web Systems', 'PHP, MySQL, JavaScript, Bootstrap', 'assets/images/project3.png', '#', '#', 3),
('Complaints & Suggestions System', 'PHP-based management system for handling complaints, suggestions, and status notifications with admin dashboard.', 'Web Systems', 'PHP, MySQL, JavaScript, Bootstrap', 'assets/images/project4.png', '#', '#', 4),
('Cafeteria Management System', 'Complete sales, invoices, products management, and daily reporting system for cafeteria operations.', 'Web Systems', 'PHP, MySQL, JavaScript, Bootstrap', 'assets/images/project5.png', '#', '#', 5),
('Business Website', 'Responsive corporate website with modern design, contact forms, and SEO optimization.', 'Websites', 'HTML5, CSS3, JavaScript, Bootstrap', 'assets/images/project6.png', '#', '#', 6);

-- =============================================
-- Services Table
-- =============================================
CREATE TABLE IF NOT EXISTS `services` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(150) NOT NULL,
    `description` TEXT NOT NULL,
    `icon` VARCHAR(100) DEFAULT NULL,
    `sort_order` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Sample services
INSERT INTO `services` (`title`, `description`, `icon`, `sort_order`) VALUES
('Mobile Application Development', 'Development of modern Android and iOS applications using Flutter with responsive interfaces and professional functionality.', 'bi-phone', 1),
('Website Development', 'Design and development of professional responsive websites for companies, organizations, businesses, and personal brands.', 'bi-globe', 2),
('PHP Web Systems', 'Development of custom PHP and MySQL management systems including dashboards, authentication, reports, and administration panels.', 'bi-code-slash', 3),
('E-Commerce Development', 'Development of online stores with product management, shopping carts, orders, customer accounts, and payment-ready architecture.', 'bi-cart-check', 4),
('Landing Page Design', 'High-converting landing pages for businesses, products, campaigns, and services that drive results.', 'bi-megaphone', 5),
('UI/UX Web Design', 'Modern, clean, and user-friendly interfaces optimized for desktop and mobile devices with great user experience.', 'bi-palette', 6),
('Database Development', 'MySQL database design, optimization, integration, and management for scalable applications.', 'bi-database', 7),
('Website Maintenance', 'Bug fixing, performance improvements, website updates, security improvements, and ongoing technical support.', 'bi-tools', 8),
('Academic & Technical Services', 'Technical documentation, research formatting, reports, presentations, and IT-related assistance.', 'bi-journal-richtext', 9);
