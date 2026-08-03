"use strict";

const BASE_REPORTES = "../assets/backend/reportes/";

const MESES_TEXTO = {
    "01": "Ene", "02": "Feb", "03": "Mar", "04": "Abr",
    "05": "May", "06": "Jun", "07": "Jul", "08": "Ago",
    "09": "Sep", "10": "Oct", "11": "Nov", "12": "Dic"
};

const DIAS_TEXTO = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];

document.addEventListener("DOMContentLoaded", () => {

    cargarReportes();

});

async function cargarReportes(){

    try {

        const respuesta = await fetch(BASE_REPORTES + "reportes.php", { credentials: "same-origin" });
        const resultado = await respuesta.json();

        if(!resultado.success){

            return;

        }

        pintarIndicadores(resultado.data.indicadores);
        pintarResumen(resultado.data.indicadores);
        crearGraficoConsultas(resultado.data.consultas_por_mes);
        crearGraficoEspecialidades(resultado.data.medicos_por_especialidad);
        crearGraficoTratamientos(resultado.data.tratamientos_por_dia);

    } catch (err) {

        console.error("Error al cargar los reportes:", err);

    }

}

function pintarIndicadores(indicadores){

    const tarjetas = document.querySelectorAll(".cards .dashboard-card span");

    if(tarjetas.length < 4){

        return;

    }

    tarjetas[0].textContent = indicadores.pacientes;
    tarjetas[1].textContent = indicadores.citas_mes;
    tarjetas[2].textContent = indicadores.medicos;
    tarjetas[3].textContent = indicadores.tratamientos_activos;

}

function pintarResumen(indicadores){

    const celdas = document.querySelectorAll(".chart-card table tbody tr td strong");

    if(celdas.length < 5){

        return;

    }

    celdas[0].textContent = indicadores.pacientes;
    celdas[1].textContent = indicadores.citas_pendientes;
    celdas[2].textContent = indicadores.consultas;
    celdas[3].textContent = indicadores.tratamientos_fin;
    celdas[4].textContent = indicadores.medicamentos;

}

function crearGraficoConsultas(datos){

    new Chart(

        document.getElementById("consultasChart"),

        {

            type: "bar",

            data: {

                labels: datos.map((fila) => MESES_TEXTO[fila.mes.slice(5, 7)] ?? fila.mes),

                datasets: [{

                    label: "Consultas",

                    data: datos.map((fila) => fila.total),

                    backgroundColor: "#3387F3",

                    borderRadius: 8

                }]

            },

            options: {

                responsive: true,

                maintainAspectRatio: false,

                plugins: {

                    legend: {

                        display: false

                    }

                }

            }

        }

    );

}

function crearGraficoEspecialidades(datos){

    new Chart(

        document.getElementById("especialidadesChart"),

        {

            type: "doughnut",

            data: {

                labels: datos.map((fila) => fila.especialidad),

                datasets: [{

                    data: datos.map((fila) => fila.total),

                    backgroundColor: [

                        "#3387F3",
                        "#165FBE",
                        "#5AA5FF",
                        "#B7D8FF",
                        "#0B1F3A",
                        "#9CC8FF"

                    ]

                }]

            },

            options: {

                responsive: true,

                maintainAspectRatio: false,

                plugins: {

                    legend: {

                        position: "bottom"

                    }

                }

            }

        }

    );

}

function crearGraficoTratamientos(datos){

    new Chart(

        document.getElementById("tratamientosChart"),

        {

            type: "line",

            data: {

                labels: datos.map((fila) => DIAS_TEXTO[new Date(fila.dia + "T00:00:00").getDay()]),

                datasets: [{

                    label: "Tratamientos",

                    data: datos.map((fila) => fila.total),

                    borderColor: "#165FBE",

                    backgroundColor: "rgba(51,135,243,.15)",

                    fill: true,

                    tension: .35

                }]

            },

            options: {

                responsive: true,

                maintainAspectRatio: false,

                plugins: {

                    legend: {

                        display: false

                    }

                }

            }

        }

    );

}
