"use strict";

/*
PRISMA
Control de sesión y acceso por roles
*/

(async () => {

    const ROLES = {
        1: "Administrador",
        2: "Médico",
        3: "Recepción",
        4: "Farmacia"
    };

    const PERMISOS = {
        1: [
            "dashboard.html",
            "pacientes.html",
            "medicos.html",
            "citas.html",
            "consultas.html",
            "tratamientos.html",
            "medicamentos.html",
            "usuarios.html",
            "roles.html",
            "reportes.html",
            "configuracion.html"
        ],

        2: [
            "dashboard.html",
            "pacientes.html",
            "citas.html",
            "consultas.html",
            "tratamientos.html",
            "medicamentos.html",
            "reportes.html"
        ],

        3: [
            "dashboard.html",
            "pacientes.html",
            "medicos.html",
            "citas.html"
        ],

        4: [
            "dashboard.html",
            "tratamientos.html",
            "medicamentos.html"
        ]
    };

    function obtenerPaginaActual() {

        const ruta = window.location.pathname;

        return ruta.substring(
            ruta.lastIndexOf("/") + 1
        );

    }

    function actualizarPerfil(usuario) {

        const nombre = document.querySelector(
            ".user-profile strong"
        );

        const rol = document.querySelector(
            ".user-profile small"
        );

        if (nombre) {
            nombre.textContent =
                usuario.nombre_usuario;
        }

        if (rol) {
            rol.textContent =
                ROLES[usuario.id_rol] ||
                "Usuario";
        }

    }

    function aplicarPermisos(usuario) {

        const idRol = Number(usuario.id_rol);

        const paginasPermitidas =
            PERMISOS[idRol] || [];

        const paginaActual =
            obtenerPaginaActual();

        if (
            paginaActual &&
            !paginasPermitidas.includes(paginaActual)
        ) {

            window.location.replace(
                "dashboard.html"
            );

            return false;
        }

        document
            .querySelectorAll(".sidebar-menu a")
            .forEach((enlace) => {

                const href =
                    enlace.getAttribute("href");

                if (!href) {
                    return;
                }

                const pagina =
                    href.substring(
                        href.lastIndexOf("/") + 1
                    );

                if (
                    pagina.endsWith(".html") &&
                    !paginasPermitidas.includes(pagina)
                ) {

                    enlace.style.display = "none";

                }

            });

        return true;

    }

    try {

        const respuesta = await fetch(
            "../assets/backend/auth/verificar.php",
            {
                credentials: "same-origin"
            }
        );

        if (!respuesta.ok) {

            window.location.replace(
                "../login.html"
            );

            return;

        }

        const resultado =
            await respuesta.json();

        if (
            !resultado.success ||
            !resultado.usuario
        ) {

            window.location.replace(
                "../login.html"
            );

            return;

        }

        const usuario =
            resultado.usuario;

        actualizarPerfil(usuario);

        aplicarPermisos(usuario);

    } catch (error) {

        console.error(
            "Error al verificar la sesión:",
            error
        );

        window.location.replace(
            "../login.html"
        );

    }

})();


document.addEventListener(
    "DOMContentLoaded",
    () => {

        const enlacesLogout =
            document.querySelectorAll(
                '#btnLogout, .sidebar-footer a[href="../login.html"]'
            );

        enlacesLogout.forEach((enlace) => {

            enlace.addEventListener(
                "click",
                async (event) => {

                    event.preventDefault();

                    try {

                        await fetch(
                            "../assets/backend/auth/logout.php",
                            {
                                method: "POST",
                                credentials: "same-origin"
                            }
                        );

                    } catch (error) {

                        console.error(
                            "Error al cerrar sesión:",
                            error
                        );

                    } finally {

                        window.location.replace(
                            "../login.html"
                        );

                    }

                }
            );

        });

    }
);