// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StudentGrades} from "../src/StudentGrades.sol";

contract StudentGradesTest is Test {
    StudentGrades public studentGrades;
    
    address public admin;
    address public student1;
    address public student2;
    address public nonStudent;
    
    function setUp() public {
        admin = address(this); // Test contract acts as admin
        student1 = address(0x1);
        student2 = address(0x2);  
        nonStudent = address(0x3);
        
        studentGrades = new StudentGrades();
    }
    
    // Test basic functionality
    function test_AddStudent() public {
        studentGrades.addStudent(student1, "Alice", 85);
        
        (string memory name, uint256 score) = studentGrades.getStudentGrade(student1);
        assertEq(name, "Alice");
        assertEq(score, 85);
    }
    
    function test_UpdateGrade() public {
        studentGrades.addStudent(student1, "Alice", 85);
        studentGrades.updateGrade(student1, 90);
        
        (, uint256 updatedScore) = studentGrades.getStudentGrade(student1);
        assertEq(updatedScore, 90);
    }
    
    function test_StudentCanViewOwnGrade() public {
        studentGrades.addStudent(student1, "Alice", 85);
        
        vm.prank(student1);
        (string memory name, uint256 score) = studentGrades.viewMyGrade();
        assertEq(name, "Alice");
        assertEq(score, 85);
    }
    
    // Test custom errors for access control
    function test_OnlyAdminCanAddStudent() public {
        vm.prank(nonStudent);
        vm.expectRevert(abi.encodeWithSelector(StudentGrades.UnauthorizedAccess.selector, nonStudent, admin));
        studentGrades.addStudent(student1, "Alice", 85);
    }
    
    function test_OnlyStudentsCanViewGrades() public {
        vm.prank(nonStudent);
        vm.expectRevert(abi.encodeWithSelector(StudentGrades.StudentNotFound.selector, nonStudent));
        studentGrades.viewMyGrade();
    }
    
    // Test custom errors for validation
    function test_CannotAddDuplicateStudent() public {
        studentGrades.addStudent(student1, "Alice", 85);
        
        vm.expectRevert(abi.encodeWithSelector(StudentGrades.StudentAlreadyExists.selector, student1));
        studentGrades.addStudent(student1, "Bob", 90);
    }
    
    function test_CannotAddInvalidScore() public {
        vm.expectRevert(abi.encodeWithSelector(StudentGrades.InvalidScore.selector, 150, 100));
        studentGrades.addStudent(student1, "Alice", 150);
    }
    
    function test_CannotUpdateNonExistentStudent() public {
        vm.expectRevert(abi.encodeWithSelector(StudentGrades.StudentNotFound.selector, student1));
        studentGrades.updateGrade(student1, 90);
    }
}
