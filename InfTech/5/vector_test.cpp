#include <iostream>
#include <string>

using namespace std;
const int CAPACITY_INIT = 1;

template <class T>
class MyVector {
public:
    typedef T *Iterator;
    typedef const T *Const_Iterator;
    MyVector();
    MyVector(size_t size);
    MyVector(size_t size, const T &init);
    MyVector(const MyVector<T> &v);
    ~MyVector();

    size_t capacity() const;
    size_t size() const;
    bool empty() const {
        return v_size == 0;
    }
    Iterator begin();
    Const_Iterator begin() const;
    Iterator end();
    Const_Iterator end() const;
    T &front();
    T &back();
    void push_back(const T &value);
    void pop_back();
    void reserve(size_t capacity);
    void resize(size_t size);
    T &operator[](size_t index);
    MyVector<T> &operator=(const MyVector<T> &);
    void clear();

private:
    size_t v_size;
    size_t v_capacity;
    T *array;
};

//Default Constructor
template <class T>
MyVector<T>::MyVector() : v_capacity(CAPACITY_INIT),
                          v_size(0),
                          array(0) {
    cout << "Calling reserve() to have some initial capacity" << endl;
    reserve(v_capacity);
}

// Copy Constructor
template <class T>
MyVector<T>::MyVector(const MyVector<T> &v) : v_size(v.v_size),
                                              v_capacity(v.v_capacity) {
    array = new T[v_capacity];
    std::copy(v.array, v.array + capacity, array);
}

// Constructor that take size of vector to initialize
template <class T>
MyVector<T>::MyVector(size_t size) {
    v_size = size;
    v_capacity = 2 * size;
    array = new T[v_capacity];
}

/*Assignment Operator (Exception safe because 
 * I am creating a temporary before deleting the old object
 * as allocating memory might throw bad alloc exception,
 * We should never delete the old one before allocating for new)
 */
template <class T>
MyVector<T> &MyVector<T>::operator=(const MyVector<T> &v) {
    v_size = v.v_size;
    v_capacity = v.v_capacity;
    T *temp = new T[v_capacity];
    std::copy(v.array, v.array + capacity, temp);
    delete[] array;
    array = temp;
    return *this;
}

/* Constructor that accepts size and default value to initialize
 * all elements of vector
 */
template <class T>
MyVector<T>::MyVector(size_t size, const T &init) {
    v_size = size;
    v_capacity = 2 * v_size;
    array = new T[v_capacity];
    for (size_t i = 0; i < size; i++)
        array[i] = init;
}

// Implementation of begin()
template <class T>
typename MyVector<T>::Iterator MyVector<T>::begin() {
    return array;
}

//Implementation of const version of begin()
template <class T>
typename MyVector<T>::Const_Iterator MyVector<T>::begin() const {
    return array;
}

// Implementation of end()
template <class T>
typename MyVector<T>::Iterator MyVector<T>::end() {
    return array + size();
}

// Implementation of const version of end()
template <class T>
typename MyVector<T>::Const_Iterator MyVector<T>::end() const {
    return array + size();
}

// Implementation of front()
template <class T>
T &MyVector<T>::front() {
    return array[0];
}

// Implementation of end()
template <class T>
T &MyVector<T>::back() {
    return array[v_size - 1];
}

//Implementation of push_back()
template <class T>
void MyVector<T>::push_back(const T &v) {
    if (v_size >= v_capacity) {
        cout << "Calling resize() due to vector overflow(Doubling the capacity)" << endl;
        resize(v_capacity);
    }
    array[v_size++] = v;
}

// Implementation of pop_back()
template <class T>
void MyVector<T>::pop_back() {
    if (v_size > 0) {
        (array)[v_size - 1].~T(); // Forcing destructor
        v_size--;
    }
}

// Implementation of reserve()
template <class T>
void MyVector<T>::reserve(size_t capacity) {
    cout << "Current Capacity : " << capacity << " Hence will call default constructor " << capacity << " times." << endl;
    T *newBuffer = new T[capacity];
    for (size_t i = 0; i < v_size; i++)
        newBuffer[i] = array[i];

    v_capacity = capacity;
    cout << "Clearing old array" << endl;
    delete[] array;
    cout << "Assigning to new array" << endl;
    array = newBuffer;
}

// Implementation of size()
template <class T>
size_t MyVector<T>::size() const {
    return v_size;
}

// Implementation of resize()
template <class T>
void MyVector<T>::resize(size_t capacity) {
    reserve(2 * capacity);
    v_capacity = 2 * capacity;
}

//Overloading [] operator to provide index access behaviour
template <class T>
T &MyVector<T>::operator[](size_t index) {
    return array[index];
}

// Implementation of capacity()
template <class T>
size_t MyVector<T>::capacity() const {
    return v_capacity;
}

//Destructor
template <class T>
MyVector<T>::~MyVector() {
    delete[] array;
}

// Implementation of clear()
template <class T>
void MyVector<T>::clear() {
    while (v_capacity > 0) {
        (array)[v_capacity - 1].~T();
        v_capacity--;
    }
    v_size = 0;
}

/* A sample class to that will be used to depict 
 * various behaviour of vector
 */
class A {
public:
    A(string iValue = "") : value(iValue) {
        cout << "Default Ctor A" << endl;
    }
    A(const A &ob) {
        value = ob.value;
        cout << "Copy Ctor A" << endl;
    }
    A &operator=(const A &ob) {
        value = ob.value;
        cout << "Assign A" << endl;
        return *this;
    }
    ~A() {
        cout << "Dtor A" << endl;
    }
    const string &getValue() const {
        return value;
    }

private:
    string value;
};

int main() {
    cout << "Step 1 : create vector of my class" << endl;
    MyVector<A> v;
    cout << endl
         << "Step 2 : create objects of my class" << endl;
    A *ob = new A("Ankur");
    A *ob1 = new A("Puneet");
    A *ob2 = new A("Gaurav");
    cout << endl
         << "Step 3 : pushing objects to vector" << endl;
    v.push_back(*ob);
    v.push_back(*ob1);
    v.push_back(*ob2);
    cout << endl
         << "Step 4: Using Const_Iterator to iterate over elements" << endl;
    for (MyVector<A>::Const_Iterator it = v.begin();
         it != v.end(); ++it) {
        cout << it->getValue() << endl;
    }
    cout << endl
         << "Step 5: Calling pop_back()" << endl;
    v.pop_back();
    cout << endl
         << "Step 6: Calling clear()" << endl;
    v.clear();
    cout << endl
         << "Step 7: After clear() destructing the objects created in main()" << endl;
    return 0;
}