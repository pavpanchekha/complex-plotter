from collections import namedtuple

# Leftward is toward the front of the list, rightward toward the end
class DLLNode(object):
    __slots__ = ["left", "right", "key", "value"]
    def __init__(self, left, right, key, value):
        self.left = left
        self.right = right
        self.key = key
        self.value = value

class LRUCache:
    """
    A fixed-size vanilla LRU cache.

    The ``size`` parameter in the constructor is the maximum size.  To
    use, override ``compute_value`` (and ``evice``, if you want) in a
    subclass.
    """
    
    def __init__(self, size):
        self.size = size
        self.head = None
        self.tail = None
        self.keys = {}

    def compute_value(self, key):
        """
        Called to produce a value for a given key, if no value exists
        in the cache.  Passed the key.

        To use in the cache, override this in a subclass.  The LRU
        cache is useless if this isn't overridden.
        """

        raise NotImplementedError("Override in child")

    def evict(self, key, value):
        """
        Called to do cleanup when a key is evicted.  Passed the key
        and the value.

        To use in the cache, override this in a subclass.  By default,
        this method does nothing at all.
        """
        return

    def get(self, key):
        """
        Returns the value associated with a given key in the cache, or
        computes a new one using ``compute_value``.
        """
        
        if key in self.keys:
            val = self.keys[key].value
            node = self.keys[key]
            self.extract_node(node)
            self.insert_node(node)
        else:
            val = self.compute_value(key)
            node = DLLNode(None, None, key, val)
            self.insert_node(node)
            if len(self.keys) > self.size:
                last_node = self.tail
                self.extract_node(last_node)
        return val

    def extract_node(self, node):
        """
        Extracts a node from the DLL, and sets its left and right
        pointers to None.
        """
        
        if node.left is not None:
            node.left.right = node.right
        else:
            self.head = node.right
        
        if node.right is not None:
            node.right.left = node.left
        else:
            self.tail = node.left

        node.left = None
        node.right = None

        del self.keys[node.key]

    def insert_node(self, node):
        """
        Inserts a node into the DLL, at the front.  Assumes node has
        left and right fields currently set to None.
        """

        node.right = self.head
        if self.head is not None:
            self.head.left = node
        self.head = node

        self.keys[node.key] = node
