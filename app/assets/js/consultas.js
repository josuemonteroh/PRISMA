"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("consultationModal");
    const btnNuevaConsulta = document.getElementById("btnNuevaConsulta");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("consultationForm");
    const buscador = document.getElementById("buscarConsulta");
    const tabla = document.getElementById("tablaConsultas");
    const selectPaciente = document.getElementById("paciente");

    let historiales = [];
    let pacienteSeleccionado = null;
    let editandoId = null;

    const BASE = "../assets/backend/consultas/";

    async function cargarPacientes() {

        try {

            const respuesta = await fetch("../assets/backend/pacientes/listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success) return;

            selectPaciente.innerHTML =
                '<option value="">Seleccione un paciente</option>';

            resultado.data.forEach(paciente => {

                const option = document.createElement("option");

                option.value = paciente.id;

                option.textContent = `${paciente.nombre} ${paciente.apellido}`;

                selectPaciente.appendChild(option);

            });

        } catch (error) {

            console.error(error);

        }

    }


    async function cargarHistoriales() {

        try {

            const respuesta = await fetch("../assets/backend/historiales/listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success) {
                console.error("No se pudieron cargar los historiales.");
                return;
            }

            historiales = resultado.data || [];

        } catch (error) {

            console.error("Error al cargar historiales:", error);

        }

    }


    function abrirModalNuevo() {
        editandoId = null;
        formulario.reset();

        modal.querySelector(".modal-header h2").textContent =
            "Nueva Consulta";

        modal.classList.add("active");
    }

    function cerrarModal() {
        modal.classList.remove("active");
        formulario.reset();
        editandoId = null;
    }

    function pintarFila(consulta) {
        const tr = document.createElement("tr");

        tr.dataset.consulta = JSON.stringify(consulta);

        tr.innerHTML = `
        <td>${String(consulta.id).padStart(3, "0")}</td>
        <td>${consulta.paciente ?? ""}</td>
        <td>${consulta.medico ?? ""}</td>
        <td>${consulta.cita ?? ""}</td>
        <td>${consulta.fecha ?? ""}</td>
        <td>${consulta.observaciones ?? ""}</td>
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
            editandoId = consulta.id;

            const historial = historiales.find(
                h => h.id === consulta.id_historial
            );

            if (historial) {
                selectPaciente.value = historial.id_paciente;
            }

            document.getElementById("idMedico").value =
                consulta.id_medico ?? "";

            document.getElementById("idCita").value =
                consulta.id_cita ?? "";

            document.getElementById("fecha").value =
                consulta.fecha ?? "";

            document.getElementById("observaciones").value =
                consulta.observaciones ?? "";

            modal.querySelector(".modal-header h2").textContent =
                "Editar Consulta";

            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {
            const confirmar = confirm(
                "¿Desea eliminar esta consulta?"
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
                        id: consulta.id
                    })
                });

                const resultado = await respuesta.json();

                if (!resultado.success) {
                    alert(
                        resultado.message ||
                        "No se pudo eliminar la consulta."
                    );
                    return;
                }

                alert("Consulta eliminada correctamente.");

                cargarConsultas();

            } catch (error) {
                console.error(error);

                alert(
                    "Error de conexión al eliminar la consulta."
                );
            }
        });

        tabla.appendChild(tr);
    }

    async function cargarConsultas() {
        tabla.innerHTML = "";

        try {
            const respuesta = await fetch(BASE + "listar.php", {
                credentials: "same-origin"
            });

            const resultado = await respuesta.json();

            if (!resultado.success) {
                tabla.innerHTML = `
                    <tr>
                        <td colspan="7">
                            ${resultado.message || "No se pudieron cargar las consultas."}
                        </td>
                    </tr>
                `;
                return;
            }

            if (!resultado.data || resultado.data.length === 0) {
                tabla.innerHTML = `
                    <tr>
                        <td colspan="7">
                            No hay consultas registradas.
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
                    <td colspan="7">
                        Error de conexión con el servidor.
                    </td>
                </tr>
            `;
        }
    }

    btnNuevaConsulta.addEventListener("click", abrirModalNuevo);

    botonesCerrar.forEach((boton) => {
        boton.addEventListener("click", cerrarModal);
    });

    modal.addEventListener("click", (event) => {
        if (event.target === modal) {
            cerrarModal();
        }
    });

    formulario.addEventListener("submit", async (event) => {
        event.preventDefault();

        const idPaciente = Number(selectPaciente.value);

        if (!idPaciente) {
            alert("Debe seleccionar un paciente.");
            return;
        }

        const historial = historiales.find(
            h => h.id_paciente === idPaciente
        );

        if (!historial) {
            alert("El paciente seleccionado no tiene historial clínico.");
            return;
        }

        const payload = {
            id_historial: historial.id,
            id_medico: parseInt(document.getElementById("idMedico").value),
            id_cita: parseInt(document.getElementById("idCita").value),
            fecha: document.getElementById("fecha").value,
            observaciones: document.getElementById("observaciones").value.trim()
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
                    "No se pudo guardar la consulta."
                );
                return;
            }

            alert(
                editandoId
                    ? "Consulta actualizada correctamente."
                    : "Consulta registrada correctamente."
            );

            cerrarModal();
            cargarConsultas();

        } catch (error) {
            console.error(error);
            alert("Error de conexión al guardar la consulta.");
        }
    });

    buscador.addEventListener("keyup", () => {
        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("#tablaConsultas tr").forEach((fila) => {
            fila.style.display =
                fila.textContent.toLowerCase().includes(texto)
                    ? ""
                    : "none";
        });
    });

    cargarPacientes();
    cargarHistoriales();
    cargarConsultas();
});