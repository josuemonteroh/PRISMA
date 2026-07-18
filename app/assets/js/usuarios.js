"use strict";

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("userModal");
    const btnNuevoUsuario = document.getElementById("btnNuevoUsuario");
    const botonesCerrar = document.querySelectorAll(".modal-close");
    const formulario = document.getElementById("userForm");
    const buscador = document.getElementById("buscarUsuario");
    const tabla = document.getElementById("tablaUsuarios");
    const selectRol = document.getElementById("rol");
    const campoPassword = document.getElementById("password");

    const BASE = "../assets/backend/usuarios/";
    const CATALOGOS = "../assets/backend/common/catalogos.php";

    let editandoId = null;

    function abrirModalNuevo() {
        editandoId = null;
        formulario.reset();
        campoPassword.required = true;
        campoPassword.placeholder = "********";
        modal.querySelector(".modal-header h2").textContent = "Nuevo Usuario";
        modal.classList.add("active");
    }

    function cerrarModal() {
        modal.classList.remove("active");
        formulario.reset();
        editandoId = null;
    }

    async function cargarRoles() {
        try {
            const respuesta = await fetch(CATALOGOS + "?tipo=roles", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            selectRol.innerHTML = '<option value="">Seleccione</option>';

            (resultado.data || []).forEach((rol) => {
                const option = document.createElement("option");
                option.value = rol.id;
                option.textContent = rol.nombre;
                selectRol.appendChild(option);
            });
        } catch (err) {
            selectRol.innerHTML = '<option value="">No se pudieron cargar</option>';
        }
    }

    function pintarFila(usuario) {
        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td>${String(usuario.id).padStart(3, "0")}</td>
            <td>${usuario.usuario}</td>
            <td>${usuario.correo ?? ""}</td>
            <td>${usuario.rol ?? ""}</td>
            <td>
                <span class="status ${usuario.estado === "ACTIVO" ? "active" : "inactive"}">
                    ${usuario.estado === "ACTIVO" ? "Activo" : "Inactivo"}
                </span>
            </td>
            <td class="actions">
                <button class="action-btn edit"><i class="fa-solid fa-pen"></i></button>
                <button class="action-btn delete"><i class="fa-solid fa-trash"></i></button>
            </td>
        `;

        tr.querySelector(".edit").addEventListener("click", () => {
            editandoId = usuario.id;
            document.getElementById("usuario").value = usuario.usuario ?? "";
            document.getElementById("correo").value = usuario.correo ?? "";
            campoPassword.value = "";
            campoPassword.required = false;
            campoPassword.placeholder = "Dejar en blanco para no cambiarla";
            selectRol.value = usuario.id_rol ?? "";
            document.getElementById("estado").value = usuario.estado ?? "ACTIVO";
            modal.querySelector(".modal-header h2").textContent = "Editar Usuario";
            modal.classList.add("active");
        });

        tr.querySelector(".delete").addEventListener("click", async () => {
            if (!confirm("¿Desea eliminar este usuario?")) {
                return;
            }

            try {
                const respuesta = await fetch(BASE + "eliminar.php", {
                    method: "POST",
                    credentials: "same-origin",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ id: usuario.id })
                });
                const resultado = await respuesta.json();

                if (!resultado.success) {
                    alert(resultado.message || "No se pudo eliminar el usuario.");
                    return;
                }

                cargarUsuarios();
            } catch (err) {
                alert("Error de conexión al eliminar el usuario.");
            }
        });

        tabla.appendChild(tr);
    }

    async function cargarUsuarios() {
        tabla.innerHTML = "";

        try {
            const respuesta = await fetch(BASE + "listar.php", { credentials: "same-origin" });
            const resultado = await respuesta.json();

            if (!resultado.success) {
                tabla.innerHTML = `<tr><td colspan="6">${resultado.message || "No se pudieron cargar los usuarios."}</td></tr>`;
                return;
            }

            if (!resultado.data || resultado.data.length === 0) {
                tabla.innerHTML = `<tr><td colspan="6">No hay usuarios registrados.</td></tr>`;
                return;
            }

            resultado.data.forEach(pintarFila);
        } catch (err) {
            tabla.innerHTML = `<tr><td colspan="6">Error de conexión con el servidor.</td></tr>`;
        }
    }

    btnNuevoUsuario.addEventListener("click", abrirModalNuevo);

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
            usuario: document.getElementById("usuario").value.trim(),
            correo: document.getElementById("correo").value.trim(),
            contrasena: campoPassword.value,
            id_rol: selectRol.value,
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
                alert(resultado.message || "No se pudo guardar el usuario.");
                return;
            }

            cerrarModal();
            cargarUsuarios();
        } catch (err) {
            alert("Error de conexión al guardar el usuario.");
        }
    });

    buscador.addEventListener("keyup", () => {
        const texto = buscador.value.toLowerCase();

        document.querySelectorAll("#tablaUsuarios tr").forEach((fila) => {
            fila.style.display = fila.textContent.toLowerCase().includes(texto) ? "" : "none";
        });
    });

    cargarRoles();
    cargarUsuarios();
});
