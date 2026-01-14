const button = document.querySelector('.login-btn');
const btnText = button.querySelector('.btn-text');
const btnLoader = button.querySelector('.btn-loader');

button.addEventListener('click', function (e) {
    e.preventDefault();

    // Ocultar texto y mostrar loader
    btnText.style.display = 'none';
    btnLoader.style.display = 'block';

    // Simular proceso (aquí harías tu petición real)
    setTimeout(() => {
        // Volver al estado normal
        btnText.style.display = 'block';
        btnLoader.style.display = 'none';
    }, 2000);
});