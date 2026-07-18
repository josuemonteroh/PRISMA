"use strict";

/**
 * Protege las páginas internas del dashboard.
 * Verifica contra el backend si hay una sesión activa; si no la hay,
 * redirige de inmediato al login. También conecta el enlace
 * "Cerrar sesión" del sidebar con el logout real en el backend.
 *
 * Para proteger otra página (pacientes.html, citas.html, etc.) basta
 * con incluir este mismo script antes de su JS específico.
 */
(async () => {

    try {

        const respuesta = await fetch("../assets/backend/auth/verificar.php", {
            credentials: "same-origin"
        });

        if (!respuesta.ok){

            window.location.href = "../login.html";

        }

    }catch (err){

        window.location.href = "../login.html";

    }

})();

document.addEventListener("DOMContentLoaded", () => {

    const btnLogout = document.getElementById("btnLogout");

    if (!btnLogout){

        return;

    }

    btnLogout.addEventListener("click", async (event) => {

        event.preventDefault();

        try {

            await fetch("../assets/backend/auth/logout.php", {
                method: "POST",
                credentials: "same-origin"
            });

        }finally{

            window.location.href = "../login.html";

        }

    });

});
