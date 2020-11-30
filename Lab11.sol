pragma solidity ^0.4.6;

contract Questions {
    struct Question{
        string text;
        bool answer;
        uint payment;
    }
    Question[] questions;
    address owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function remove(uint index) private{
        if (index >= questions.length) return;

        for (uint i = index; i<questions.length-1; i++){
            questions[i] = questions[i+1];
        }
        delete questions[questions.length-1];
        questions.length--;
    }
    
    function addQuestion(string question, bool ans) public payable{
        require(msg.value > 0);
        Question memory quest = Question(question, ans, msg.value);
        questions.push(quest);
    }
    
    function answerQuestion(string question, bool ans) public returns(string){
        for (uint i = 0; i < questions.length; i++) {
            if (keccak256(questions[i].text) == keccak256(question)) {
                if (ans == questions[i].answer) {
                    msg.sender.send(questions[i].payment);
                    return "Correct answer!";
                    remove(i);
                } else {
                    return "Incorrect answer!";
                }
                break;
            }
        }
        return "There is no such question!";
    }
    
    function getQuest() public returns(bool) {
        return questions[0].answer;
    }
}
