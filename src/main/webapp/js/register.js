document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('registerForm');
    const password = document.getElementById('password');
    const strengthBar = document.getElementById('passwordStrength');
    const phoneInput = document.getElementById('phone');

    // Password strength checker
    password.addEventListener('input', function() {
        const strength = checkPasswordStrength(this.value);
        updateStrengthBar(strength);
    });

    // Phone number formatter
    phoneInput.addEventListener('input', function() {
        this.value = formatPhoneNumber(this.value);
    });

    // Form validation
    form.addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
        }
    });

    function checkPasswordStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
        if (password.match(/\d/)) strength++;
        if (password.match(/[^a-zA-Z\d]/)) strength++;
        return strength;
    }

    function updateStrengthBar(strength) {
        strengthBar.className = 'password-strength';
        if (strength === 0) strengthBar.classList.add('d-none');
        else {
            strengthBar.classList.remove('d-none');
            if (strength <= 2) strengthBar.classList.add('strength-weak');
            else if (strength === 3) strengthBar.classList.add('strength-medium');
            else strengthBar.classList.add('strength-strong');
        }
    }

    function formatPhoneNumber(value) {
        const phone = value.replace(/\D/g, '');
        if (phone.length < 4) return phone;
        if (phone.length < 7) return `${phone.slice(0, 3)}-${phone.slice(3)}`;
        return `${phone.slice(0, 3)}-${phone.slice(3, 6)}-${phone.slice(6, 10)}`;
    }

    function validateForm() {
        let isValid = true;
        const email = document.getElementById('email').value;
        const age = document.getElementById('age').value;

        if (!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)) {
            showError('email', 'Please enter a valid email address');
            isValid = false;
        }

        if (age < 13 || age > 120) {
            showError('age', 'Age must be between 13 and 120');
            isValid = false;
        }

        if (password.value.length < 8) {
            showError('password', 'Password must be at least 8 characters long');
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
});