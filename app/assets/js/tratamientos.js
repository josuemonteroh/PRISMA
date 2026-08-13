"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("treatmentModal");
    const btnNuevoTratamiento = document.getElementById("btnNuevoTratamiento");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("treatmentForm");
    const buscador = document.getElementById("buscarTratamiento");
    const tabla = document.getElementById("tablaTratamientos");

    const BASE = "../assets/backend/tratamientos/";
    const BASE_CONSULTAS = "../assets/backend/consultas/";
    const BASE_MEDICAMENTOS = "../assets/backend/medicamentos/";

    let editandoId = null;

    async function cargarConsultas() {

        const select = document.getElementById("idConsulta");

        select.innerHTML = `
            <option value="">
                Seleccione una consulta
            </option>
        `;

        try {

            const respuesta = await fetch(BASE_CONSULTAS + "listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success || !resultado.data) {
                return;
            }

            resultado.data.forEach((consulta) => {

                const option = document.createElement("option");

                option.value = consulta.id;

                option.textContent =
                    `Consulta #${consulta.id} - ${consulta.paciente ?? "Paciente"} - ${consulta.fecha ?? ""}`;

                select.appendChild(option);

            });

        } catch (error) {

            console.error(
                "Error al cargar consultas:",
                error
            );

        }

    }

    async function cargarMedicamentos() {

        const select = document.getElementById("idMedicamento");

        select.innerHTML = `
            <option value="">
                Seleccione un medicamento
            </option>
        `;

        try {

            const respuesta = await fetch(BASE_MEDICAMENTOS + "listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success || !resultado.data) {
                return;
            }

            resultado.data.forEach((medicamento) => {

                const option = document.createElement("option");

                option.value = medicamento.id;

                option.textContent =
                    `${medicamento.nombre ?? "Medicamento"}${medicamento.concentracion ? " - " + medicamento.concentracion : ""}`;

                select.appendChild(option);

            });

        } catch (error) {

            console.error(
                "Error al cargar medicamentos:",
                error
            );

        }

    }

    async function abrirModalNuevo() {

        editandoId = null;
        formulario.reset();

        await Promise.all([
            cargarConsultas(),
            cargarMedicamentos()
        ]);

        modal.querySelector(".modal-header h2").textContent =
            "Nuevo Tratamiento";

        modal.classList.add("active");
    }

    function cerrarModal() {

        modal.classList.remove("active");

        formulario.reset();

        editandoId = null;
    }

    function pintarFila(tratamiento) {

        const tr = document.createElement("tr");

        tr.dataset.tratamiento = JSON.stringify(tratamiento);

        tr.innerHTML = `
            <td>${String(tratamiento.id).padStart(3, "0")}</td>
            <td>${tratamiento.consulta ?? ""}</td>
            <td>${tratamiento.medicamento ?? ""}</td>
            <td>${tratamiento.dosis ?? ""}</td>
            <td>${tratamiento.frecuencia ?? ""}</td>
            <td>${tratamiento.duracion_dias} días</td>
            <td>${tratamiento.fecha_inicio ?? ""}</td>

            <td class="actions">

                <button class="action-btn edit">

                    <i class="fa-solid fa-pen"></i>

                </button>

                <button class="action-btn delete">

                    <i class="fa-solid fa-trash"></i>

                </button>

            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", async () => {

            editandoId = tratamiento.id;

            await Promise.all([
                cargarConsultas(),
                cargarMedicamentos()
            ]);

            document.getElementById("idConsulta").value =
                tratamiento.id_consulta ?? "";

            document.getElementById("idMedicamento").value =
                tratamiento.id_medicamento ?? "";

            document.getElementById("dosis").value =
                tratamiento.dosis ?? "";

            document.getElementById("frecuencia").value =
                tratamiento.frecuencia ?? "";

            document.getElementById("duracionDias").value =
                tratamiento.duracion_dias ?? "";

            document.getElementById("fechaInicio").value =
                tratamiento.fecha_inicio ?? "";

            modal.querySelector(".modal-header h2").textContent =
                "Editar Tratamiento";

            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {

            const confirmar = confirm(
                "¿Desea eliminar este tratamiento?"
            );

            if (!confirmar) {
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
                        id: tratamiento.id
                    })
                });

                const resultado = await respuesta.json();

                if (!resultado.success) {

                    alert(
                        resultado.message ||
                        "No se pudo eliminar el tratamiento."
                    );

                    return;
                }

                alert(
                    "Tratamiento eliminado correctamente."
                );

                await cargarTratamientos();

            } catch (error) {

                console.error(error);

                alert(
                    "Error de conexión al eliminar el tratamiento."
                );

            }

        });

        tabla.appendChild(tr);
    }

    async function cargarTratamientos() {

        tabla.innerHTML = "";

        try {

            const respuesta = await fetch(BASE + "listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success) {

                tabla.innerHTML = `
                    <tr>
                        <td colspan="8">
                            ${resultado.message || "No se pudieron cargar los tratamientos."}
                        </td>
                    </tr>
                `;

                return;
            }

            if (!resultado.data || resultado.data.length === 0) {

                tabla.innerHTML = `
                    <tr>
                        <td colspan="8">
                            No hay tratamientos registrados.
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
                    <td colspan="8">
                        Error de conexión con el servidor.
                    </td>
                </tr>
            `;

        }

    }

    formulario.addEventListener("submit", async (event) => {

        event.preventDefault();

        const payload = {
            id_consulta: parseInt(
                document.getElementById("idConsulta").value
            ),
            id_medicamento: parseInt(
                document.getElementById("idMedicamento").value
            ),
            dosis: document.getElementById("dosis").value.trim(),
            frecuencia: document.getElementById("frecuencia").value.trim(),
            duracion_dias: parseInt(
                document.getElementById("duracionDias").value
            ),
            fecha_inicio: document.getElementById("fechaInicio").value
        };

        try {

            const endpoint = editandoId
                ? "actualizar.php"
                : "guardar.php";

            if (editandoId) {
                payload.id = editandoId;
            }

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
                    "No se pudo guardar el tratamiento."
                );

                return;
            }

            alert(resultado.message);

            cerrarModal();

            await cargarTratamientos();

        } catch (error) {

            console.error(error);

            alert(
                "Error de conexión con el servidor."
            );

        }

    });

    btnNuevoTratamiento.addEventListener(
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

    buscador.addEventListener("keyup", () => {

        const texto = buscador.value.toLowerCase();

        document.querySelectorAll(
            "#tablaTratamientos tr"
        ).forEach((fila) => {

            fila.style.display =
                fila.textContent.toLowerCase().includes(texto)
                    ? ""
                    : "none";

        });

    });

    cargarTratamientos();

});