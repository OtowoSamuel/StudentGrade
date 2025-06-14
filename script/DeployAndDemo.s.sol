// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {StudentGrades} from "../src/StudentGrades.sol";

contract DeployAndDemo is Script {
    StudentGrades public studentGrades;
    
    address constant ALICE = 0x1111111111111111111111111111111111111111;
    address constant BOB = 0x2222222222222222222222222222222222222222;
    
    function run() public {
        vm.startBroadcast();

        // Deploy contract
        studentGrades = new StudentGrades();
        console.log("StudentGrades deployed at:", address(studentGrades));
        console.log("Admin:", studentGrades.admin());

        // Add students
        studentGrades.addStudent(ALICE, "Alice", 85);
        studentGrades.addStudent(BOB, "Bob", 92);
        console.log("Added 2 students");
        
        // Update a grade
        studentGrades.updateGrade(ALICE, 88);
        console.log("Updated Alice's grade to 88");

        vm.stopBroadcast();
        
        // Show results
        console.log("");
        console.log("=== Student Grades ===");
        (string memory aliceName, uint256 aliceScore) = studentGrades.getStudentGrade(ALICE);
        (string memory bobName, uint256 bobScore) = studentGrades.getStudentGrade(BOB);
        
        console.log(aliceName, ":", aliceScore);
        console.log(bobName, ":", bobScore);
        console.log("Total students:", studentGrades.getTotalStudents());
        
        // Demonstrate custom errors
        console.log("");
        console.log("=== Custom Error Demo ===");
        console.log("Custom errors are more gas efficient than require strings!");
    }
}
