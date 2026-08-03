"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("doctorModal");
    const btnNuevoMedico = document.getElementById("btnNuevoMedico");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("doctorForm");
    const buscador = document.getElementById("buscarMedico");
    const tabla = document.getElementById("tablaMedicos");
    const selectEspecialidad = document.getElementById("especialidadModal");

    const BASE = "../assets/backend/medicos/";
    const CATALOGOS = "../assets/backend/common/catalogos.php";

    let editandoId = null;
    let especialidadesMap = {};

    function abrirModalNuevo() {
        editandoId = null;
        formulario.reset();
        modal.querySelector(".modal-header h2").textContent = "Nuevo Médico";
        modal.classList.add("active");
    }

    function cerrarModal() {
        modal.classList.remove("active");
        formulario.reset();
        editandoId = null;
    }

    async function cargarEspecialidades() {
        try {
            const respuesta = await fetch(CATALOGOS + "?tipo=especialidades", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            selectEspecialidad.innerHTML = '<option value="">Seleccione</option>';

            (resultado.data || []).forEach((especialidad) => {
                especialidadesMap[especialidad.id] = especialidad.nombre;
                const option = document.createElement("option");
                option.value = especialidad.id;
                option.textContent = especialidad.nombre;
                selectEspecialidad.appendChild(option);
            });
        } catch (err) {
            selectEspecialidad.innerHTML = '<option value="">No se pudieron cargar</option>';
        }
    }

    function pintarFila(medico) {
        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td>${String(medico.id).padStart(3, "0")}</td>
            <td>Dr(a). ${medico.nombre} ${medico.apellido}</td>
            <td>${medico.numero_colegiatura ?? ""}</td>
            <td>${especialidadesMap[medico.id_especialidad] ?? ""}</td>
            <td>${medico.telefono ?? ""}</td>
            <td>${medico.correo ?? ""}</td>
            <td class="actions">
                <button class="action-btn edit"><i class="fa-solid fa-pen"></i></button>
                <button class="action-btn delete"><i class="fa-solid fa-trash"></i></button>
            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", () => {
            editandoId = medico.id;
            document.getElementById("nombre").value = medico.nombre ?? "";
            document.getElementById("apellido").value = medico.apellido ?? "";
            document.getElementById("telefono").value = medico.telefono ?? "";
            document.getElementById("correo").value = medico.correo ?? "";
            document.getElementById("licencia").value = medico.numero_colegiatura ?? "";
            selectEspecialidad.value = medico.id_especialidad ?? "";
            modal.querySelector(".modal-header h2").textContent = "Editar Médico";
            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {
            if (!confirm("¿Desea eliminar este médico?")) {
                return;
            }

            try {
                const respuesta = await fetch(BASE + "eliminar.php", {
                    method: "POST",
                    credentials: "same-origin",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ id: medico.id })
                });
                const resultado = await respuesta.json();

                if (!resultado.success) {
                    alert(resultado.message || "No se pudo eliminar el médico.");
                    return;
                }

                cargarMedicos();
            } catch (err) {
                alert("Error de conexión al eliminar el médico.");
            }
        });

        tabla.appendChild(tr);
    }

    async function cargarMedicos() {
        tabla.innerHTML = "";

        try {
            const respuesta = await fetch(BASE + "listar.php", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            if (!resultado.success) {
                tabla.innerHTML = `<tr><td colspan="7">${resultado.message || "No se pudieron cargar los médicos."}</td></tr>`;
                return;
            }

            if (!resultado.data || resultado.data.length === 0) {
                tabla.innerHTML = `<tr><td colspan="7">No hay médicos registrados.</td></tr>`;
                return;
            }

            resultado.data.forEach(pintarFila);
        } catch (err) {
            tabla.innerHTML = `<tr><td colspan="7">Error de conexión con el servidor.</td></tr>`;
        }
    }

    btnNuevoMedico.addEventListener("click", abrirModalNuevo);

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
            telefono: document.getElementById("telefono").value.trim(),
            correo: document.getElementById("correo").value.trim(),
            numero_colegiatura: document.getElementById("licencia").value.trim(),
            id_especialidad: selectEspecialidad.value
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
                alert(resultado.message || "No se pudo guardar el médico.");
                return;
            }

            cerrarModal();
            cargarMedicos();
        } catch (err) {
            alert("Error de conexión al guardar el médico.");
        }
    });

    buscador.addEventListener("keyup", () => {
        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("#tablaMedicos tr").forEach((fila) => {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    });

    (async () => {
        await cargarEspecialidades();
        cargarMedicos();
    })();
});
