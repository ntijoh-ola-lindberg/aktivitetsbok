var ta = document.querySelectorAll('textarea');
if (ta) {
    ta.forEach(input => input.addEventListener('input', function () {
        this.style.height = 'auto';
        this.style.height = this.scrollHeight + 'px';
    }));
    ta.forEach(input => input.addEventListener('click', function () {
        this.style.height = 'auto';
        this.style.height = this.scrollHeight + 'px';
    }));
}