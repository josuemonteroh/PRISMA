"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const btnGuardar = document.getElementById("btnGuardarConfiguracion");

    if(!btnGuardar){

        return;

    }

    /*GUARDAR CONFIGURACIÓN */

    btnGuardar.addEventListener("click", () => {

        alert("La configuración se ha guardado correctamente.");

    });

    /*RESTAURAR CONFIGURACIÓN */

    const btnRestaurar = document.querySelector(".btn-secondary");

    btnRestaurar.addEventListener("click", () => {

        const confirmar = confirm(
            "¿Desea restaurar la configuración predeterminada?"
        );

        if(confirmar){

            document
                .querySelectorAll("input[type='text'], input[type='email']")
                .forEach((input) => {

                    input.value = "";

                });

            document
                .querySelectorAll("select")
                .forEach((select) => {

                    select.selectedIndex = 0;

                });

            document
                .querySelectorAll("input[type='checkbox']")
                .forEach((checkbox) => {

                    checkbox.checked = false;

                });

            alert("La configuración fue restaurada.");

        }

    });

});