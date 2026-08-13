"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("medicineModal");
    const btnNuevoMedicamento = document.getElementById("btnNuevoMedicamento");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("medicineForm");
    const buscador = document.getElementById("buscarMedicamento");
    const tabla = document.getElementById("tablaMedicamentos");

    const BASE = "../assets/backend/medicamentos/";

    let editandoId = null;

    function abrirModalNuevo() {

        editandoId = null;

        formulario.reset();

        modal.querySelector(".modal-header h2").textContent =
            "Nuevo Medicamento";

        modal.classList.add("active");

    }

    function cerrarModal() {

        modal.classList.remove("active");

        formulario.reset();

        editandoId = null;

    }

    function pintarFila(medicamento) {

        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td>${String(medicamento.id).padStart(3, "0")}</td>
            <td>${medicamento.nombre}</td>
            <td>${medicamento.descripcion ?? ""}</td>
            <td>${medicamento.presentacion ?? ""}</td>
            <td>${medicamento.concentracion ?? ""}</td>

            <td class="actions">

                <button class="action-btn edit">

                    <i class="fa-solid fa-pen"></i>

                </button>

                <button class="action-btn delete">

                    <i class="fa-solid fa-trash"></i>

                </button>

            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", () => {

            editandoId = medicamento.id;

            document.getElementById("nombreMedicamento").value =
                medicamento.nombre ?? "";

            document.getElementById("categoria").value =
                medicamento.descripcion ?? "";

            document.getElementById("presentacion").value =
                medicamento.presentacion ?? "";

            document.getElementById("dosis").value =
                medicamento.concentracion ?? "";

            modal.querySelector(".modal-header h2").textContent =
                "Editar Medicamento";

            modal.classList.add("active");

        });

        tr.querySelector(".delete").addEventListener("click", async () => {

            if (!confirm("¿Desea eliminar este medicamento?")) {
                return;
            }

            try {

                const respuesta = await fetch(BASE + "eliminar.php", {
                    method: "POST",
                    credentials: "same-origin",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        id: medicamento.id
                    })
                });

                const resultado = await respuesta.json();

                if (!resultado.success) {

                    alert(
                        resultado.message ||
                        "No se pudo eliminar el medicamento."
                    );

                    return;

                }

                await cargarMedicamentos();

            } catch (error) {

                console.error(error);

                alert(
                    "Error de conexión al eliminar el medicamento."
                );

            }

        });

        tabla.appendChild(tr);

    }

    async function cargarMedicamentos() {

        tabla.innerHTML = "";

        try {

            const respuesta = await fetch(BASE + "listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success) {

                tabla.innerHTML = `
                    <tr>
                        <td colspan="6">
                            ${resultado.message || "No se pudieron cargar los medicamentos."}
                        </td>
                    </tr>
                `;

                return;

            }

            if (!resultado.data || resultado.data.length === 0) {

                tabla.innerHTML = `
                    <tr>
                        <td colspan="6">
                            No hay medicamentos registrados.
                        </td>
                    </tr>
                `;

                return;

            }

            resultado.data.forEach(pintarFila);

        } catch (error) {

            console.error(error);

            tabla.innerHTML = `
                <tr>
                    <td colspan="6">
                        Error de conexión con el servidor.
                    </td>
                </tr>
            `;

        }

    }

    btnNuevoMedicamento.addEventListener(
        "click",
        abrirModalNuevo
    );

    botonesCerrar.forEach((boton) => {

        boton.addEventListener(
            "click",
            cerrarModal
        );

    });

    modal.addEventListener("click", (event) => {

        if (event.target === modal) {
            cerrarModal();
        }

    });

    formulario.addEventListener("submit", async (event) => {

        event.preventDefault();

        const payload = {
            nombre: document
                .getElementById("nombreMedicamento")
                .value
                .trim(),

            descripcion: document
                .getElementById("categoria")
                .value
                .trim(),

            presentacion: document
                .getElementById("presentacion")
                .value
                .trim(),

            concentracion: document
                .getElementById("dosis")
                .value
                .trim()
        };

        const endpoint = editandoId
            ? "actualizar.php"
            : "guardar.php";

        if (editandoId) {
            payload.id = editandoId;
        }

        try {

            const respuesta = await fetch(BASE + endpoint, {
                method: "POST",
                credentials: "same-origin",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(payload)
            });

            const resultado = await respuesta.json();

            if (!resultado.success) {

                alert(
                    resultado.message ||
                    "No se pudo guardar el medicamento."
                );

                return;

            }

            cerrarModal();

            await cargarMedicamentos();

        } catch (error) {

            console.error(error);

            alert(
                "Error de conexión al guardar el medicamento."
            );

        }

    });

    buscador.addEventListener("keyup", () => {

        const texto =
            buscador.value.toLowerCase();

        document
            .querySelectorAll("#tablaMedicamentos tr")
            .forEach((fila) => {

                fila.style.display =
                    fila.textContent
                        .toLowerCase()
                        .includes(texto)
                        ? ""
                        : "none";

            });

    });

    cargarMedicamentos();

});