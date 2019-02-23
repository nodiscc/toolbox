#Description: Example Python __init__ method, class methods and 'self'

#simple class
class Airplane:
    pass

# create 2 instances of the Airplane class
airplane1 = Airplane()
airplane2 = Airplane()

#############################################

# simple class with __init__ method
class Airplane:
    def __init__(self):
        print "A new instance got made!"

# create 2 instances of the Airplane class
airplane1 = Airplane()
# "A new instance got made!"
airplane2 = Airplane()
# "A new instance got made!"

#############################################

class Airplane:
    def __init__(self):
        print "A new instance got made!"
    # define a class method
    def fly(self):
        print "I'm flying!"

# create 2 instances of the Airplane class
airplane1 = Airplane()
# "A new instance got made!"
airplane2 = Airplane()
# "A new instance got made!"
airplane1.fly()
# "I'm flying!"