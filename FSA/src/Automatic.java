import java.io.*;
import java.util.*;

public class Automatic {
    private static final String ANSI_PURPLE = "\u001B[35m";
    private static final String ANSI_RESET = "\u001B[0m";
    private String pattern;
    private String text;
    private String alphabet;
    private int patternLength;
    private int textLength;
    private int alphabetLength;
    private int[][] transitions;
    private ArrayList<Integer> solutions;

    // O(|text| + |pattern|*|alphabet|)
    private Automatic(String args[]) {
        readDataFromFiles(args);
        textLength = text.length();
        patternLength = pattern.length();
        alphabetLength = alphabet.length();
        transitions = new int[patternLength + 1][alphabetLength];
        solutions = new ArrayList<>();

        computeTransitionFunction();
        search();
        printTransitionTable();
        printSolutions();
    }

    private void readDataFromFiles(String args[]) {
        try {
            System.out.println("How many args: " + args.length);
            pattern = new Scanner(new FileReader(args[0])).next();
            text = new Scanner(new FileReader(args[1])).next();
            if(args.length == 2)
                alphabet = findAlphabet();
            else
                alphabet = new Scanner(new FileReader(args[2])).next();
            System.out.println("Files read correctly");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return;
        }
        System.out.println("Pattern: " + pattern);
        System.out.println("Text: " + text);
        System.out.println("Alphabet: " + alphabet);
    }

    private String findAlphabet() {
        Set<Character> set = new LinkedHashSet<>();
        for(char c: text.toCharArray())
            set.add(c);

        return set.toString().replaceAll("\\[|]","").replaceAll(",","").replaceAll(" ", "");
    }

    private void computeTransitionFunction() {
        String pq;
        int k;
        char a;

        for(int q = 0; q <= patternLength; q++) {
            for(int i = 0; i < alphabetLength; i++) {
                a = alphabet.charAt(i);
                k = Math.min(patternLength + 1, q + 2);
                pq = pattern.substring(0, q) + a;
                do {
                    k--;
                }
                while (!pq.endsWith(pattern.substring(0, k)));
                transitions[q][i] = k;
            }
        }
    }

    private void search() {
        int q = 0;
        for(int i = 0; i < textLength; i++) {
            q = deltaFunc(q, text.charAt(i));
            if(q == patternLength) solutions.add(i - patternLength + 1);
        }
    }

    //deltaFunc -> max length of pattern prefix
    private int deltaFunc(int q, char c) {
        for(int i = 0; i < alphabetLength; i++)
            if(c == alphabet.charAt(i)) return transitions[q][i];
        System.out.println("Character not from the alphabet");
        return 0;
    }

    private void printTransitionTable() {
        System.out.println("Transition table: ");
        for(int i = 0; i <= patternLength; i++) {
            for(int j = 0; j < alphabetLength; j++)
                System.out.print(transitions[i][j] + " ");
            System.out.println();
        }
    }

    private void printSolutions() {
        System.out.println("\nSolutions: " + solutions);
        System.out.println();
        for(int i : solutions) {
            for(int c = 0; c < textLength; c++) {
                if(c >= i && c < (i + patternLength))
                    System.out.print(ANSI_PURPLE);
                System.out.print(text.charAt(c) + ANSI_RESET);
            }
            System.out.println();
        }
    }

    public static void main(String args[]) {
        new Automatic(args);
    }
}
