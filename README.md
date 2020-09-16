# Futbol

## Table of Contents
  * [Introduction](#introduction)
  * [Learning Goals](#learning-goals)
  * [Contributors](#contributors)
  * [Technologies](#technologies)
  * [Design](#design)
  * [Single Responsibility](#sr)
  * [Images](#images)

## Introduction

  This project was a collaborative project that allows the team to showcase a knowledge of handling CSV files and being able to analyze and synthesis data. This
  project was meant to allow for further knowledge exploration of Object Oriented Solutions.

## Learning Goals  

  * Build classes with single responsibilities.
  * Write organized readable code.
  * Use TDD as a design strategy
  * Design an Object Oriented Solution to a problem
  * Practice algorithmic thinking
  * Work in a group
  * Use Pull Requests to collaborate among multiple partners

## Contributors

  * Kate Tester
  * Cydnee Owens
  * George Soderholm

## Technologies

- Ruby

## Design
The following design structure is based on a school analogy and is also visually represented in the image below, FB Image 1. In this analogy, StatTracker represents the school's principal, the Managers represent the school's teachers, the Children Managers represent the teacher's assistants and the Classes represents the teacher's students. Additionally, each teacher has access to the tutor, who represents a Module.  

### Pricipal/Stat Tracker
Using our school analogy, our StatTracker (Principal Tracker) oversees the entire school and directly manages all of the teachers. She receives and delegates requests to and from the teachers, Mrs. Game-Teams,  Ms. Games, and Mr. Teams, and the teacher's assistants, Miss GT-Leagues, Mr. GT-Seasons, for specific student information, function and keeps track of all of the topics that each teacher has in their lesson plan. The principal uses this knowledge to navigate and delegate tasks. 

### Teacher/Manager Class
Each teachers teaches a specific subject, like math or music, and is responsible for creating the lesson plan, assignments, and tests. This is similar to the managers who handle a specific function and are responsible for loading the CSV data files needed to process and store that information. Each teacher has their own class of students. 

### Students/Individual Data
The student knows all of the information about their individual self and can answer most questions the teacher asks them like their name, date of birth, or hair color. When the teacher asks a student a question and they are unable to answer, the teacher can teach the students how to use the information they already know to answer the question, or if the student's answer is dependent on information from another student in another class, the teacher can ask the principal to ask another teacher for the information. 

### TAs/Child Classes
Teachers with larger classes can have teacher's assistants, who help offload some of the responsibility from the teacher. They adhere to the same lesson plans as the teacher and can also add to the teacher's lesson plan. Additionally they only work with the class of students the teacher has. The teacher's assistants can send and receive requests from the principal, as well as, request and teach information to and from the students. This demonstrates how Parent Managers can have Children Managers. The children have access to all of the parents attributes and methods and can help offload some of the work that the parent would otherwise own. 

### Module/Tutor
All teachers have access to the tutor, who has a set of skills that all of them can utilize to help process certain functions. This is the role of the Module, who stores methods that can be access by all the managers to help execute certain functions in methods.

## Single Responsibility
- **Averageable** - Module with two shared methods that calculate averages with or without count
- **Game-Team** - Initializes all the data for every new game-team object from the game-teams CSV
- **Game-Team League** - Utilizes game-team data created by parent GT to execute all league statistic methods
- **Game-Team Season** - Utilizes game-team data created by parent GT to execute all season statistic methods
- **Game-Team Manager** - Creates all the game-teams and datasets from the CSV file to be utilize by children season and league and holds all the datasets for the team statistics
- **StatTracker** - The hub for all data needed. Like a controller that navigates all the statistic requests and delegates appropriately.
- **Game Manager** - Creates all the game and datasets from the CSV file and holds all the methods to execute all game statistic methods
- **Game** - Initializes all the data for every new game object from the games CSV
- **Team Manager** - Creates all the team and datasets from the CSV file and holds all the methods to execute the team statistic methods
- **Team** - Initializes all the data for every new team object from the teams CSV

## Images
Image citations can be found here: https://docs.google.com/document/d/1GrEsUKfjBDVhiVzSCZs1trcw4YmRFVTeCoHbjmDiBuE/edit
![Futbol -1](https://user-images.githubusercontent.com/67389821/93383152-768fd100-f820-11ea-9eef-e6c2d3f7d1e7.jpeg)






Starter repository for the [Turing School](https://turing.io/) Futbol project.
