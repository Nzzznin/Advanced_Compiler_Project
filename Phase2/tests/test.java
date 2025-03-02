import java.util.Scanner;

public class IfForExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Prompt the user to enter a positive number
        System.out.print("Enter a positive number: ");
        int n = scanner.nextInt();

        // Check if the entered number is positive using an if statement
        if (n > 0) {
            System.out.println("You entered a positive number.");

            // Use a for loop to print numbers from 1 to the entered number
            System.out.println("Counting from 1 to " + n + ":");
            for (int i = 1; i <= n; i++) {
                System.out.print(i + " ");
            }
            System.out.println(); // Move to the next line after printing the numbers
        } else {
            System.out.println("Please enter a positive number.");
        }

        System.out.println("End of the program.");
    }
    a
}