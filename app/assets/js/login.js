"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const loginForm = document.querySelector(".login-form");

    if (!loginForm){

        return;

    }

    const error = document.querySelector(".alert-error");
    const btnSubmit = loginForm.querySelector("button[type='submit']");

    loginForm.addEventListener("submit", async (event) => {

        event.preventDefault();

        error.style.display = "none";

        const usuario = document.getElementById("username").value.trim();
        const contrasena = document.getElementById("password").value;

        btnSubmit.disabled = true;

        try {

            const respuesta = await fetch("assets/backend/auth/login.php", {

                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                credentials: "same-origin",
                body: JSON.stringify({ usuario, contrasena })

            });

            const resultado = await respuesta.json();

            if (resultado.success){

                window.location.href = "pages/dashboard.html";

            }else{

                error.textContent = resultado.message || "Usuario o contraseña incorrectos.";
                error.style.display = "flex";
                document.getElementById("username").focus();

            }

        }catch (err){

            error.textContent = "No se pudo conectar con el servidor. Intente de nuevo.";
            error.style.display = "flex";

        }finally{

            btnSubmit.disabled = false;

        }

    });

});
