document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('loginForm');
    const togglePassword = document.querySelector('.toggle-password');
    const passwordField = document.getElementById('password');

    // Toggle password visibility
    togglePassword.addEventListener('click', function() {
        const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordField.setAttribute('type', type);
        this.innerHTML = type === 'password' ? 
            '<i class="bi bi-eye"></i>' : 
            '<i class="bi bi-eye-slash"></i>';
    });

    // Form validation
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
        }
    });

    function validateForm() {
        let isValid = true;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
            showError('email', 'Please enter a valid email address');
            isValid = false;
        }

        if (password.length < 6) {
            showError('password', 'Password must be at least 6 characters');
            isValid = false;
        }

        return isValid;
    }

    function showError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.textContent = message;
        field.classList.add('is-invalid');
        field.parentNode.appendChild(errorDiv);
    }

    // Clear validation on input
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('input', function() {
            this.classList.remove('is-invalid');
            const feedback = this.parentNode.querySelector('.invalid-feedback');
            if (feedback) {
                feedback.remove();
            }
        });
    });
});