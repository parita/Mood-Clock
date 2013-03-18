int led = 13;
int motorA = 8;
int motorB = 9;
const int analogPin = A0;
const int threshold = 300;   // an arbitrary threshold level that's in the range of the analog input
int count = 0;
unsigned long int prev_time = 0;
int prevValue=0, encoder_val=0;
int a = 1;
unsigned long int count_limit =0;

// the setup routine runs once when you press reset:
void setup() {
  pinMode(led, OUTPUT);
  pinMode(motorA, OUTPUT);
  pinMode(motorB, OUTPUT);
  pinMode(analogPin, INPUT);
  Serial.begin(9600);     
}

int check(int analogValue) {
if (analogValue > threshold) {
   digitalWrite(led,HIGH);
//delay(500);
   return 1; 
  } 
  else {
    digitalWrite(led,LOW);
//delay(500);
    return 0; 
  }
}

int get_code(char ch){
int code;
switch (ch){
case '0': code=0;break;
case '1': code=1;break;
case '2': code=2;break;
case '3': code=3;break;
case '4': code=4;break;
case '5': code=5;break;
case '6': code=6;break;
case '7': code=7;break;
case '8': code=8;break;
case '9': code=9;break;
case 'a': code=10;break;
case 'b': code=11;break;
}
return code;
}

void fwd(){
digitalWrite(motorA, HIGH);
digitalWrite(motorB, LOW);
}

void bkwd(){
digitalWrite(motorA, LOW);
digitalWrite(motorB, HIGH);
}

void stop(){
digitalWrite(motorA, HIGH);
digitalWrite(motorB, HIGH);
}

void encoder()
{
  int analogValue = analogRead(analogPin);
  encoder_val = check(analogValue);
  if(encoder_val!=prevValue)
    {
    count++; 
    prevValue = encoder_val;
    }
}

// the loop routine runs over and over again forever:
void loop() {
//int analogValue = analogRead(analogPin);

//Serial.println('a');

  if(Serial.available())
  {
	char pcode=Serial.read();
	delay(500);
	char bcode=Serial.read();
        
        Serial.println(pcode);
        Serial.println(bcode);
        
        int p_code=get_code(pcode);
	int b_code=get_code(bcode);
	
        if(p_code==0)
          p_code=12;
        if(b_code==0)
          b_code=12;
	
        unsigned long int time = b_code*60 + (p_code*5);  
   	unsigned long int diff = abs(time-prev_time);
        prev_time=time;
        
        if(diff>=720)
          diff = diff-720;
	
        count_limit = (diff*6*36);
        count_limit = count_limit/280;
        
        Serial.println(count_limit);
	
        while(1)
	{
	bkwd();
	
	encoder();
	if(count>=count_limit)
	  {
          stop();
          count=0;
          prevValue = 0, 
          encoder_val = 0;
          break;
          }

	}
delay(50000);
	  
}

}



