"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("patientModal");
    const btnNuevoPaciente = document.getElementById("btnNuevoPaciente");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("patientForm");
    const buscador = document.getElementById("buscarPaciente");
    const tabla = document.getElementById("tablaPacientes");

    const BASE = "../assets/backend/pacientes/";

    let editandoId = null;

    function abrirModalNuevo() {
        editandoId = null;
        formulario.reset();
        modal.querySelector(".modal-header h2").textContent = "Nuevo Paciente";
        modal.classList.add("active");
    }

    function cerrarModal() {
        modal.classList.remove("active");
        formulario.reset();
        editandoId = null;
    }

    function pintarFila(paciente) {
        const tr = document.createElement("tr");
        tr.dataset.paciente = JSON.stringify(paciente);

        tr.innerHTML = `
            <td>${String(paciente.id).padStart(3, "0")}</td>
            <td>${paciente.nombre} ${paciente.apellido}</td>
            <td>${paciente.cedula ?? ""}</td>
            <td>${paciente.telefono ?? ""}</td>
            <td>${paciente.correo ?? ""}</td>
            <td>${paciente.sexo === "M" ? "Masculino" : paciente.sexo === "F" ? "Femenino" : ""}</td>
            <td class="actions">
                <button class="action-btn edit"><i class="fa-solid fa-pen"></i></button>
                <button class="action-btn delete"><i class="fa-solid fa-trash"></i></button>
            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", () => {
            editandoId = paciente.id;
            document.getElementById("nombre").value = paciente.nombre ?? "";
            document.getElementById("apellido").value = paciente.apellido ?? "";
            document.getElementById("cedula").value = paciente.cedula ?? "";
            document.getElementById("telefono").value = paciente.telefono ?? "";
            document.getElementById("correo").value = paciente.correo ?? "";
            document.getElementById("fechaNacimiento").value = paciente.fecha_nacimiento ?? "";
            document.getElementById("sexo").value = paciente.sexo ?? "";
            document.getElementById("direccion").value = paciente.direccion ?? "";
            modal.querySelector(".modal-header h2").textContent = "Editar Paciente";
            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {
            if (!confirm("¿Desea eliminar este paciente?")) {
                return;
            }

            try {
                const respuesta = await fetch(BASE + "eliminar.php", {
                    method: "POST",
                    credentials: "same-origin",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ id: paciente.id })
                });
                const resultado = await respuesta.json();

                if (!resultado.success) {
                    alert(resultado.message || "No se pudo eliminar el paciente.");
                    return;
                }

                cargarPacientes();
            } catch (err) {
                alert("Error de conexión al eliminar el paciente.");
            }
        });

        tabla.appendChild(tr);
    }

    async function cargarPacientes() {
        tabla.innerHTML = "";

        try {
            const respuesta = await fetch(BASE + "listar.php", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            if (!resultado.success) {
                tabla.innerHTML = `<tr><td colspan="7">${resultado.message || "No se pudieron cargar los pacientes."}</td></tr>`;
                return;
            }

            if (!resultado.data || resultado.data.length === 0) {
                tabla.innerHTML = `<tr><td colspan="7">No hay pacientes registrados.</td></tr>`;
                return;
            }

            resultado.data.forEach(pintarFila);
        } catch (err) {
            tabla.innerHTML = `<tr><td colspan="7">Error de conexión con el servidor.</td></tr>`;
        }
    }

    btnNuevoPaciente.addEventListener("click", abrirModalNuevo);

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
            nombre: document.getElementById("nombre").value.trim(),
            apellido: document.getElementById("apellido").value.trim(),
            cedula: document.getElementById("cedula").value.trim(),
            telefono: document.getElementById("telefono").value.trim(),
            correo: document.getElementById("correo").value.trim(),
            fecha_nacimiento: document.getElementById("fechaNacimiento").value,
            sexo: document.getElementById("sexo").value,
            direccion: document.getElementById("direccion").value.trim()
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
                alert(resultado.message || "No se pudo guardar el paciente.");
                return;
            }

            cerrarModal();
            cargarPacientes();
        } catch (err) {
            alert("Error de conexión al guardar el paciente.");
        }
    });

    buscador.addEventListener("keyup", () => {
        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("#tablaPacientes tr").forEach((fila) => {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    });

    cargarPacientes();
});
