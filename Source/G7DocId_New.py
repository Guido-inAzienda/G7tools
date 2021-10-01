import uuid, base64, sys

def GeneraID(quantiID):
    conta = 0

    while (conta < quantiID):
    
        uuid1 = base64.b85encode(uuid.uuid4().bytes).decode('ascii')

        if (uuid1.find('"') < 0) and (uuid1.find("'") < 0) and (uuid1.find(" ") < 0):            
            print(uuid1)    
            conta = conta + 1
    
if __name__ == '__main__':

    if len(sys.argv) > 1:
        quantiID = sys.argv[1]
    else:
      quantiID = 1      

    GeneraID(int(quantiID))
