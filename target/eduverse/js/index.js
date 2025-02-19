document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Add loading animation for book downloads
    document.querySelectorAll('.download-btn').forEach(button => {
        button.addEventListener('click', function() {
            this.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Downloading...';
            setTimeout(() => {
                this.innerHTML = '<i class="bi bi-download"></i> Download PDF';
            }, 2000);
        });
    });
});