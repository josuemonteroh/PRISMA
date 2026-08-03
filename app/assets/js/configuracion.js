"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const btnGuardar = document.getElementById("btnGuardarConfiguracion");

    if(!btnGuardar){

        return;

    }

    const BASE = "../assets/backend/usuarios/";

    const inputUsuario = document.getElementById("cuentaUsuario");
    const inputCorreo = document.getElementById("cuentaCorreo");
    const inputContrasena = document.getElementById("cuentaContrasena");

    async function cargarPerfil(){

        try {

            const respuesta = await fetch(BASE + "perfil.php", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            if(!resultado.success){

                return;

            }

            inputUsuario.value = resultado.data.usuario;
            inputCorreo.value = resultado.data.correo;

        } catch (err) {

            console.error("Error al cargar el perfil:", err);

        }

    }

    cargarPerfil();

    btnGuardar.addEventListener("click", async () => {

        const payload = {
            usuario: inputUsuario.value.trim(),
            correo: inputCorreo.value.trim(),
            contrasena: inputContrasena.value
        };

        if(payload.usuario === "" || payload.correo === ""){

            alert("Usuario y correo son obligatorios.");
            return;

        }

        try {

            const respuesta = await fetch(BASE + "perfil.php", {
                method: "POST",
                credentials: "same-origin",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            });
            const resultado = await respuesta.json();

            if(!resultado.success){

                alert(resultado.message || "No se pudo guardar la configuración.");
                return;

            }

            inputContrasena.value = "";
            alert("La configuración se ha guardado correctamente.");

        } catch (err) {

            alert("Error de conexión al guardar la configuración.");

        }

    });

    const btnRestaurar = document.querySelector(".btn-secondary");

    btnRestaurar.addEventListener("click", () => {

        const confirmar = confirm(
            "¿Desea restaurar la configuración predeterminada?"
        );

        if(confirmar){

            cargarPerfil();
            inputContrasena.value = "";

            document
                .querySelectorAll(".settings-card select")
                .forEach((select) => {

                    select.selectedIndex = 0;

                });

            document
                .querySelectorAll(".settings-card input[type='checkbox']")
                .forEach((checkbox) => {

                    checkbox.checked = false;

                });

            alert("La configuración fue restaurada.");

        }

    });

});
