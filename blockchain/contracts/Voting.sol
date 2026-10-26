// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    // 候选人结构体
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // 合约管理员
    address public admin;
    // 候选人数组
    Candidate[] public candidates;
    // 记录已投票的地址
    mapping(address => bool) public hasVoted;

    // 事件
    event CandidateAdded(uint256 id, string name);
    event Voted(address indexed voter, uint256 candidateId);

    // 修饰器：仅管理员
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // 构造函数，部署者成为管理员
    constructor() {
        admin = msg.sender;
    }

    // 添加候选人（仅管理员）
    function addCandidate(string memory _name) public onlyAdmin {
        uint256 candidateId = candidates.length;
        candidates.push(
            Candidate({id: candidateId, name: _name, voteCount: 0})
        );
        emit CandidateAdded(candidateId, _name);
    }

    // 投票函数，每个地址只能投1票
    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    // 获取全部候选人
    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    // 获取候选人总数
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    // 根据id获取单个候选人信息
    function getCandidate(uint256 _candidateId) public view returns (Candidate memory) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        return candidates[_candidateId];
    }

    // 查询地址是否投过票
    function checkIfVoted(address _voter) public view returns (bool) {
        return hasVoted[_voter];
    }
}