"use strict";

document.addEventListener("DOMContentLoaded", () => {

    cargarFecha();

    crearGraficoPacientes();

    crearGraficoCitas();

});

/* FECHA */

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

/* PACIENTES POR SEXO */

function crearGraficoPacientes(){

    const canvas = document.getElementById("patientsChart");

    if(!canvas){

        return;

    }

    new Chart(canvas,{

        type:"doughnut",

        data:{

            labels:[

                "Femenino",

                "Masculino"

            ],

            datasets:[{

                data:[138,110],

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

/* ESTADO DE CITAS */

function crearGraficoCitas(){

    const canvas = document.getElementById("appointmentsChart");

    if(!canvas){

        return;

    }

    new Chart(canvas,{

        type:"bar",

        data:{

            labels:[

                "Pendientes",

                "Confirmadas",

                "Finalizadas",

                "Canceladas"

            ],

            datasets:[{

                label:"Citas",

                data:[12,28,10,4],

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