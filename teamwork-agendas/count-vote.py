###Write a function that takes in a list and finds the majority vote inside it. Each letter in the least means an individual vote in\
###favour of that letter. You can use the following list to test your function:
votes=["A", "A", "A", "B", "C", "A"]
def majority_vote(votes):
    return max(votes,key=votes.count)
print("The winner is", majority_vote(votes))