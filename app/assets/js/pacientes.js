"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("patientModal");

    const btnNuevoPaciente = document.getElementById("btnNuevoPaciente");

    const botonesCerrar = document.querySelectorAll(".modal-close");

    const formulario = document.getElementById("patientForm");

    const buscador = document.getElementById("buscarPaciente");

    /*ABRIR MODAL */

    btnNuevoPaciente.addEventListener("click", () => {

        modal.classList.add("active");

    });

    /* CERRAR MODAL */

    botonesCerrar.forEach((boton) => {

        boton.addEventListener("click", () => {

            modal.classList.remove("active");

            formulario.reset();

        });

    });

    /* CERRAR AL HACER CLICK AFUERA */

    modal.addEventListener("click", (event) => {

        if(event.target === modal){

            modal.classList.remove("active");

            formulario.reset();

        }

    });

    /* GUARDAR */

    formulario.addEventListener("submit", (event) => {

        event.preventDefault();

        alert("Paciente registrado correctamente.");

        formulario.reset();

        modal.classList.remove("active");

    });

    /*BUSCADOR*/

    buscador.addEventListener("keyup", () => {

        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("tbody tr").forEach((fila) => {

            fila.style.display = fila.textContent.toLowerCase().includes(texto)

                ? ""

                : "none";

        });

    });

    /* EDITAR*/

    document.querySelectorAll(".edit").forEach((boton) => {

        boton.addEventListener("click", () => {

            modal.classList.add("active");

        });

    });

    /* ELIMINAR */

    document.querySelectorAll(".delete").forEach((boton) => {

        boton.addEventListener("click", () => {

            const confirmar = confirm("¿Desea eliminar este paciente?");

            if(confirmar){

                boton.closest("tr").remove();

            }

        });

    });

});