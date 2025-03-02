public class WhileLoopExample {
    public static void main(String[] args) {
        // Use a static number (e.g., 3)
        int number = 3;

        // Validate the static input using a while loop
        while (number <= 0) {
            System.out.println("The static number must be positive.");
            // In a real scenario, you might want to change the static number here
            number = 3; // Setting it to a new value for the purpose of the example
        }

        // Print a message with the validated positive number
        System.out.println("You entered a positive number: " + number);

        System.out.println("End of the program.");
    }
}
