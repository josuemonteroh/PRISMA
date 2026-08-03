"use strict";

const BASE_REPORTES = "../assets/backend/reportes/";

const ESTADOS_CITA_TEXTO = {
    PROGRAMADA: "Programada",
    CONFIRMADA: "Confirmada",
    ATENDIDA: "Atendida",
    CANCELADA: "Cancelada"
};

document.addEventListener("DOMContentLoaded", () => {

    cargarFecha();

    cargarDashboard();

});

function cargarFecha(){

    const fecha = document.getElementById("currentDate");

    if(!fecha){

        return;

    }

    const hoy = new Date();

    fecha.textContent = hoy.toLocaleDateString("es-CR",{

        day:"numeric",

        month:"long",

        year:"numeric"

    });

}

async function cargarDashboard(){

    try {

        const respuesta = await fetch(BASE_REPORTES + "dashboard.php", { credentials: "same-origin" });
        const resultado = await respuesta.json();

        if(!resultado.success){

            return;

        }

        pintarIndicadores(resultado.data.indicadores);
        crearGraficoPacientes(resultado.data.pacientes_por_sexo);
        crearGraficoCitas(resultado.data.citas_por_estado);
        pintarCitasRecientes(resultado.data.citas_recientes);

    } catch (err) {

        console.error("Error al cargar el dashboard:", err);

    }

}

function pintarIndicadores(indicadores){

    const tarjetas = document.querySelectorAll(".cards .dashboard-card span");

    if(tarjetas.length < 5){

        return;

    }

    tarjetas[0].textContent = indicadores.pacientes;
    tarjetas[1].textContent = indicadores.medicos;
    tarjetas[2].textContent = indicadores.citas_hoy;
    tarjetas[3].textContent = indicadores.tratamientos_activos;
    tarjetas[4].textContent = "₡" + Number(indicadores.facturacion_mes).toLocaleString("es-CR");

}

function crearGraficoPacientes(datos){

    const canvas = document.getElementById("patientsChart");

    if(!canvas){

        return;

    }

    const etiquetas = { F: "Femenino", M: "Masculino" };

    new Chart(canvas,{

        type:"doughnut",

        data:{

            labels: datos.map((fila) => etiquetas[fila.sexo] ?? fila.sexo),

            datasets:[{

                data: datos.map((fila) => fila.total),

                backgroundColor:[

                    "#3387F3",

                    "#0B1F3A"

                ],

                borderWidth:0,

                hoverOffset:10

            }]

        },

        options:{

            responsive:true,

            maintainAspectRatio:false,

            plugins:{

                legend:{

                    position:"bottom",

                    labels:{

                        usePointStyle:true,

                        padding:20

                    }

                }

            }

        }

    });

}

function crearGraficoCitas(datos){

    const canvas = document.getElementById("appointmentsChart");

    if(!canvas){

        return;

    }

    new Chart(canvas,{

        type:"bar",

        data:{

            labels: datos.map((fila) => ESTADOS_CITA_TEXTO[fila.estado] ?? fila.estado),

            datasets:[{

                label:"Citas",

                data: datos.map((fila) => fila.total),

                backgroundColor:[

                    "#3387F3",

                    "#2F80ED",

                    "#5AA5FF",

                    "#9CC8FF"

                ],

                borderRadius:8

            }]

        },

        options:{

            responsive:true,

            maintainAspectRatio:false,

            plugins:{

                legend:{

                    display:false

                }

            },

            scales:{

                y:{

                    beginAtZero:true,

                    ticks:{

                        stepSize:5

                    }

                }

            }

        }

    });

}

function pintarCitasRecientes(filas){

    const tabla = document.querySelector(".table-container table tbody");

    if(!tabla){

        return;

    }

    tabla.innerHTML = "";

    if(!filas || filas.length === 0){

        tabla.innerHTML = `<tr><td colspan="4">No hay citas registradas.</td></tr>`;
        return;

    }

    filas.forEach((fila) => {

        const tr = document.createElement("tr");

        tr.innerHTML = `
            <td>${fila.paciente}</td>
            <td>${fila.medico}</td>
            <td>${fila.fecha ?? ""}</td>
            <td>${ESTADOS_CITA_TEXTO[fila.estado] ?? fila.estado}</td>
        `;

        tabla.appendChild(tr);

    });

}