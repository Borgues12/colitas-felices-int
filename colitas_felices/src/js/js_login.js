function togglePassword() {
    //getElementById toma un elemento por su ID
    //toma el elemento de contraseña en el login
    var passwordField = document.getElementById('txt_password');
    //toma el icono del ojo
    var eyeIcon = document.getElementById('eyeIcon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        //setAttribute cambia los atributos de un objeto
        eyeIcon.setAttribute('icon', 'fa6-solid:eye-slash');
    } else {
        passwordField.type = 'password';
        eyeIcon.setAttribute('icon', 'fa6-solid:eye');
    }
}