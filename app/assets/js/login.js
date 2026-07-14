"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const loginForm = document.querySelector(".login-form");

    if (!loginForm){

        return;

    }

    const USER = {

        username: "admin@prisma.com",
        password: "Grupo2"

    };

    const error = document.querySelector(".alert-error");

    loginForm.addEventListener("submit", (event) => {

        event.preventDefault();

        error.style.display = "none";

        const username = document.getElementById("username").value.trim();

        const password = document.getElementById("password").value;

        if (
            username === USER.username &&
            password === USER.password
        ){

            window.location.href = "pages/dashboard.html";

        }else{

            error.style.display = "flex";

            document.getElementById("username").focus();

        }

    });

});