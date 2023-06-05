#' Data from Loudness Block Experiment 2022
#'
#' This data set represents an experimental study conducted to examine
#' participants' perception and estimation of time to contact (TTC) in relation
#' to approaching cars. The study was designed to investigate the influence of
#' loudness on the judgments of TTC. The experimental design incorporated
#' variations in two key factors: the velocity of the approaching car
#' (Velocity) and the Time to contact (TTC).
#' To investigate the impact of amplified stimuli and their presentation order, participants
#' were assigned to one of two conditions: starting with the first
#' block where the car sound was either amplified or not (gainBlock1).
#' Additionally, the subsequent blocks of the experiment were presented
#' to participants either blockwise or in an interleaved manner (loudnessVariation).They were
#' then required to estimate the time to contact (Estimated_TTC)
#' based on their perception of when the approaching car would
#' reach them. Additionally, the velocity of the car at the moment
#' it becomes visually occluded (vOcc) was recorded as a relevant variable.
#' the sound of approaching cars while being immersed in a virtual environment
#' that simulated both visual and auditory cues of a road scene.
#' The time to contact was manipulated, presenting participants with different
#' durations for the approaching car's arrival and different velocities.
#' Different levels of sound pressure levels were presented either blockwise or interleaved.
#'
#' @format ## `loudness_block`
#' A data frame with 11,040 rows and 13 columns:
#' \describe{
#'   \item{Participantnr}{participant identification code}
#'   \item{Condition}{Experimental Condition}
#'   \item{Velocity}{Velocity of the approaching car}
#'   \item{GaindB}{Amplification of the car sound in dB SPL}
#'   \item{gainBlock1}{Amplification of the car sound in dB SPL presented in the first block}
#'   \item{loudnessVariation}{Experimental Condition, either blockwise or interleaved presentation of different loudness conditions}
#'   \item{TTC}{Presented Time to contact (Independent variable)}
#'   \item{Estimated_TTC}{Time to contact estimated by the participant}
#'   \item{vOcc}{velocity at occlusion}
#'
#' }
"loudness_block"
