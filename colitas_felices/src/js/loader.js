$(window).on('load', function () {

    // Si ya cargó antes en esta sesión, ocultar inmediatamente
    if (sessionStorage.getItem('visitado')) {
        $('#preloader').remove(); // lo elimina del DOM directamente
        return;
    }

    // Primera visita — mostrar loader y ocultarlo al terminar
    $('#preloader').addClass('hidden');
    sessionStorage.setItem('visitado', 'true');
});