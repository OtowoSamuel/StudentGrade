// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract StudentGrades {

    // State variables
    address public admin;
    
    // Struct to store student information
    struct Student {
        string name;
        uint256 score;
        bool exists;
    }
    
    mapping(address => Student) public students;
    address[] public studentAddresses;
    
    // Custom Errors
    error UnauthorizedAccess(address caller, address expected);
    error StudentNotFound(address student);
    error StudentAlreadyExists(address student);
    error InvalidScore(uint256 score, uint256 maxScore);
    
    // Events
    event StudentAdded(address indexed studentAddress, string name);
    event GradeUpdated(address indexed studentAddress, uint256 newScore);
    
    // Modifiers
    modifier onlyAdmin() {
        if (msg.sender != admin) {
            revert UnauthorizedAccess(msg.sender, admin);
        }
        _;
    }
    
    modifier onlyStudent() {
        if (!students[msg.sender].exists) {
            revert StudentNotFound(msg.sender);
        }
        _;
    }
    
    modifier studentExists(address _student) {
        if (!students[_student].exists) {
            revert StudentNotFound(_student);
        }
        _;
    }
    
    // Constructor
    constructor() {
        admin = msg.sender;
    }
    
    // Admin functions
    function addStudent(address _studentAddress, string memory _name, uint256 _score) 
        public 
        onlyAdmin 
    {
        if (students[_studentAddress].exists) {
            revert StudentAlreadyExists(_studentAddress);
        }
        if (_score > 100) {
            revert InvalidScore(_score, 100);
        }
        
        students[_studentAddress] = Student({
            name: _name,
            score: _score,
            exists: true
        });
        
        studentAddresses.push(_studentAddress);
        
        emit StudentAdded(_studentAddress, _name);
    }
    
    function updateGrade(address _studentAddress, uint256 _newScore) 
        public 
        onlyAdmin 
        studentExists(_studentAddress) 
    {
        if (_newScore > 100) {
            revert InvalidScore(_newScore, 100);
        }
        
        students[_studentAddress].score = _newScore;
        
        emit GradeUpdated(_studentAddress, _newScore);
    }
    
    // Student functions
    function viewMyGrade() public view onlyStudent returns (string memory name, uint256 score) {
        Student memory student = students[msg.sender];
        return (student.name, student.score);
    }
    
    // Public view functions
    function getStudentGrade(address _studentAddress) 
        public 
        view 
        studentExists(_studentAddress) 
        returns (string memory name, uint256 score) 
    {
        Student memory student = students[_studentAddress];
        return (student.name, student.score);
    }
    
    function getTotalStudents() public view returns (uint256) {
        return studentAddresses.length;
    }
    
    function getAllStudents() public view returns (address[] memory) {
        return studentAddresses;
    }
}
