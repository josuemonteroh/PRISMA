"use strict";

document.addEventListener("DOMContentLoaded", () => {

    /*  CONSULTAS POR MES */

    new Chart(

        document.getElementById("consultasChart"),

        {

            type: "bar",

            data: {

                labels: [

                    "Ene",
                    "Feb",
                    "Mar",
                    "Abr",
                    "May",
                    "Jun"

                ],

                datasets: [{

                    label: "Consultas",

                    data: [

                        45,
                        52,
                        61,
                        57,
                        70,
                        64

                    ],

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

    /* PACIENTES POR ESPECIALIDAD*/

    new Chart(

        document.getElementById("especialidadesChart"),

        {

            type: "doughnut",

            data: {

                labels: [

                    "Medicina General",
                    "Cardiología",
                    "Pediatría",
                    "Dermatología"

                ],

                datasets: [{

                    data: [

                        40,
                        25,
                        20,
                        15

                    ],

                    backgroundColor: [

                        "#3387F3",
                        "#165FBE",
                        "#5AA5FF",
                        "#B7D8FF"

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

    /* TRATAMIENTOS ACTIVOS */

    new Chart(

        document.getElementById("tratamientosChart"),

        {

            type: "line",

            data: {

                labels: [

                    "Lun",
                    "Mar",
                    "Mié",
                    "Jue",
                    "Vie",
                    "Sáb",
                    "Dom"

                ],

                datasets: [{

                    label: "Tratamientos",

                    data: [

                        18,
                        22,
                        24,
                        21,
                        26,
                        28,
                        25

                    ],

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

});