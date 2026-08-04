"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("appointmentModal");
    const btnNuevaCita = document.getElementById("btnNuevaCita");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("appointmentForm");
    const buscador = document.getElementById("buscarCita");
    const tabla = document.getElementById("tablaCitas");
    const selectPaciente = document.getElementById("paciente");
    const selectMedico = document.getElementById("medico");
    const selectConsultorio = document.getElementById("consultorio");

    const BASE = "../assets/backend/citas/";
    const CATALOGOS = "../assets/backend/common/catalogos.php";

    const ESTADOS_TEXTO = {
        PROGRAMADA: "Programada",
        CONFIRMADA: "Confirmada",
        ATENDIDA: "Atendida",
        CANCELADA: "Cancelada"
    };

    const ESTADOS_CLASE = {
        PROGRAMADA: "scheduled",
        CONFIRMADA: "confirmed",
        ATENDIDA: "attended",
        CANCELADA: "cancelled"
    };

    let editandoId = null;
    const pacientesMap = {};
    const medicosMap = {};
    const consultoriosMap = {};

    function abrirModalNuevo() {
        editandoId = null;
        formulario.reset();
        modal.querySelector(".modal-header h2").textContent = "Nueva Cita";
        modal.classList.add("active");
    }

    function cerrarModal() {
        modal.classList.remove("active");
        formulario.reset();
        editandoId = null;
    }

    async function cargarCatalogo(tipo, select, textoVacio, mapa) {
        try {
            const respuesta = await fetch(CATALOGOS + "?tipo=" + tipo, { credentials: "same-origin" });
            const resultado = await respuesta.json();

            select.innerHTML = `<option value="">${textoVacio}</option>`;

            (resultado.data || []).forEach((item) => {
                if (mapa) {
                    mapa[item.id] = item.nombre;
                }
                const option = document.createElement("option");
                option.value = item.id;
                option.textContent = item.nombre;
                select.appendChild(option);
            });
        } catch (err) {
            select.innerHTML = `<option value="">No se pudo cargar</option>`;
        }
    }

    function pintarFila(cita) {
        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td>${String(cita.id).padStart(3, "0")}</td>
            <td>${pacientesMap[cita.id_paciente] ?? ""}</td>
            <td>${medicosMap[cita.id_medico] ?? ""}</td>
            <td>${cita.fecha ?? ""}</td>
            <td>${cita.hora ?? ""}</td>
            <td>
                <span class="status ${ESTADOS_CLASE[cita.estado] ?? ""}">
                    ${ESTADOS_TEXTO[cita.estado] ?? cita.estado}
                </span>
            </td>
            <td class="actions">
                <button class="action-btn edit"><i class="fa-solid fa-pen"></i></button>
                <button class="action-btn delete"><i class="fa-solid fa-trash"></i></button>
            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", () => {
            editandoId = cita.id;
            selectPaciente.value = cita.id_paciente ?? "";
            selectMedico.value = cita.id_medico ?? "";
            selectConsultorio.value = cita.id_consultorio ?? "";
            document.getElementById("fecha").value = cita.fecha ?? "";
            document.getElementById("hora").value = cita.hora ?? "";
            document.getElementById("motivo").value = cita.motivo ?? "";
            document.getElementById("estado").value = cita.estado ?? "PROGRAMADA";
            modal.querySelector(".modal-header h2").textContent = "Editar Cita";
            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {
            if (!confirm("¿Desea eliminar esta cita?")) {
                return;
            }

            try {
                const respuesta = await fetch(BASE + "eliminar.php", {
                    method: "POST",
                    credentials: "same-origin",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ id: cita.id })
                });
                const resultado = await respuesta.json();

                if (!resultado.success) {
                    alert(resultado.message || "No se pudo eliminar la cita.");
                    return;
                }

                cargarCitas();
            } catch (err) {
                alert("Error de conexión al eliminar la cita.");
            }
        });

        tabla.appendChild(tr);
    }

    async function cargarCitas() {
        tabla.innerHTML = "";

        try {
            const respuesta = await fetch(BASE + "listar.php", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            if (!resultado.success) {
                tabla.innerHTML = `<tr><td colspan="7">${resultado.message || "No se pudieron cargar las citas."}</td></tr>`;
                return;
            }

            if (!resultado.data || resultado.data.length === 0) {
                tabla.innerHTML = `<tr><td colspan="7">No hay citas registradas.</td></tr>`;
                return;
            }

            resultado.data.forEach(pintarFila);
        } catch (err) {
            tabla.innerHTML = `<tr><td colspan="7">Error de conexión con el servidor.</td></tr>`;
        }
    }

    btnNuevaCita.addEventListener("click", abrirModalNuevo);

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

        const payload = {
            id_paciente: selectPaciente.value,
            id_medico: selectMedico.value,
            id_consultorio: selectConsultorio.value,
            fecha: document.getElementById("fecha").value,
            hora: document.getElementById("hora").value,
            motivo: document.getElementById("motivo").value.trim(),
            estado: document.getElementById("estado").value
        };

        const endpoint = editandoId ? "actualizar.php" : "guardar.php";
        if (editandoId) {
            payload.id = editandoId;
        }

        try {
            const respuesta = await fetch(BASE + endpoint, {
                method: "POST",
                credentials: "same-origin",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload)
            });
            const resultado = await respuesta.json();

            if (!resultado.success) {
                alert(resultado.message || "No se pudo guardar la cita.");
                return;
            }

            cerrarModal();
            cargarCitas();
        } catch (err) {
            alert("Error de conexión al guardar la cita.");
        }
    });

    buscador.addEventListener("keyup", () => {
        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("#tablaCitas tr").forEach((fila) => {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    });

    (async () => {
        await Promise.all([
            cargarCatalogo("pacientes", selectPaciente, "Seleccione un paciente", pacientesMap),
            cargarCatalogo("medicos", selectMedico, "Seleccione un médico", medicosMap),
            cargarCatalogo("consultorios", selectConsultorio, "Seleccione un consultorio", consultoriosMap)
        ]);
        cargarCitas();
    })();
});
