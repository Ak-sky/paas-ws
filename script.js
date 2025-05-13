// Mobile navigation toggle
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Highlight active nav link on scroll
    window.addEventListener('scroll', function() {
        const sections = document.querySelectorAll('section[id]');
        const scrollY = window.pageYOffset;
        
        sections.forEach(section => {
            const sectionHeight = section.offsetHeight;
            const sectionTop = section.offsetTop - 100;
            const sectionId = section.getAttribute('id');
            
            if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                document.querySelector('.nav-links a[href="#' + sectionId + '"]')?.classList.add('active');
            } else {
                document.querySelector('.nav-links a[href="#' + sectionId + '"]')?.classList.remove('active');
            }
        });
    });
    
    // Form submission handling for demo requests
    const demoLinks = document.querySelectorAll('a.hero-primary');
    demoLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.textContent.includes('Schedule a Demo')) {
                e.preventDefault();
                alert('Thank you for your interest in AgroScan AI! A member of our team will contact you shortly to schedule your personalized demo.');
            }
        });
    });
    
    // Pricing toggle functionality
    const pricingButtons = document.querySelectorAll('.pricing-btn');
    pricingButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const plan = this.closest('.pricing-card').querySelector('.pricing-header h3').textContent;
            alert(`Thank you for your interest in our ${plan} plan! Please fill out the contact form and one of our representatives will help you get started.`);
        });
    });
    
    // Testimonial carousel for mobile
    function setupTestimonialCarousel() {
        if (window.innerWidth < 768) {
            const testimonials = document.querySelectorAll('.testimonial-card');
            if (testimonials.length > 1) {
                let currentIndex = 0;
                
                // Hide all except first
                for (let i = 1; i < testimonials.length; i++) {
                    testimonials[i].style.display = 'none';
                }
                
                // Create navigation dots
                const dotsContainer = document.createElement('div');
                dotsContainer.className = 'testimonial-dots';
                dotsContainer.style.display = 'flex';
                dotsContainer.style.justifyContent = 'center';
                dotsContainer.style.marginTop = '20px';
                
                for (let i = 0; i < testimonials.length; i++) {
                    const dot = document.createElement('span');
                    dot.style.height = '10px';
                    dot.style.width = '10px';
                    dot.style.backgroundColor = i === 0 ? 'var(--primary)' : '#ccc';
                    dot.style.borderRadius = '50%';
                    dot.style.margin = '0 5px';
                    dot.style.cursor = 'pointer';
                    dot.dataset.index = i;
                    
                    dot.addEventListener('click', function() {
                        showTestimonial(parseInt(this.dataset.index));
                    });
                    
                    dotsContainer.appendChild(dot);
                }
                
                const testimonialSection = document.querySelector('.testimonial-grid');
                testimonialSection.after(dotsContainer);
                
                // Function to show a specific testimonial
                function showTestimonial(index) {
                    testimonials.forEach((testimonial, i) => {
                        testimonial.style.display = i === index ? 'block' : 'none';
                    });
                    
                    // Update dots
                    document.querySelectorAll('.testimonial-dots span').forEach((dot, i) => {
                        dot.style.backgroundColor = i === index ? 'var(--primary)' : '#ccc';
                    });
                    
                    currentIndex = index;
                }
                
                // Auto-rotate testimonials
                setInterval(() => {
                    currentIndex = (currentIndex + 1) % testimonials.length;
                    showTestimonial(currentIndex);
                }, 5000);
            }
        }
    }
    
    // Call on load and resize
    setupTestimonialCarousel();
    window.addEventListener('resize', setupTestimonialCarousel);
    
    // Add CSS class for scroll-triggered animations
    const animatedElements = document.querySelectorAll('.feature-card, .step, .pricing-card');
    
    // Intersection Observer for animations
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });
    
    // Observe each element
    animatedElements.forEach(element => {
        observer.observe(element);
    });
    
    // Add animation styles dynamically
    const styleSheet = document.createElement('style');
    styleSheet.textContent = `
        .feature-card, .step, .pricing-card {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }
        
        .feature-card.animate, .step.animate, .pricing-card.animate {
            opacity: 1;
            transform: translateY(0);
        }
        
        .feature-card:nth-child(2), .step:nth-child(2), .pricing-card:nth-child(2) {
            transition-delay: 0.2s;
        }
        
        .feature-card:nth-child(3), .step:nth-child(3), .pricing-card:nth-child(3) {
            transition-delay: 0.4s;
        }
        
        .feature-card:nth-child(4), .step:nth-child(4) {
            transition-delay: 0.6s;
        }
        
        .feature-card:nth-child(5) {
            transition-delay: 0.8s;
        }
        
        .feature-card:nth-child(6) {
            transition-delay: 1s;
        }
    `;
    document.head.appendChild(styleSheet);
});